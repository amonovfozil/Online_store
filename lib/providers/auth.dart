import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../servises/http_exteption.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  DateTime? _expireTime;
  String? _UserID;
  Timer? autoLogoutTimer;

  static const epiKey = 'AIzaSyCZe8g1i7Hq68cR2KhRFEuDv18IyZNZlWQ';
  bool get isAuth {
    return _token != null;
  }

  String? get UserID {
    return _UserID;
  }

  String? get Token {
    if (_expireTime != null &&
        _expireTime!.isAfter(DateTime.now()) &&
        _token != null) {
      // token mavjud

      return _token;
    } else {
      // token mavjud emas
      return null;
    }
  }

  Future<void> _Authenticatia(
      String email, String passwords, String SignSigment) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$SignSigment?key=$epiKey');

    try {
      final respons = await http.post(
        url,
        body: json.encode(
          {
            "email": email,
            "password": passwords,
            "returnSecureToken": true,
          },
        ),
      );
      final data = jsonDecode(respons.body);

      if (data['error'] != null) {
        throw HttpException(data['error']['message']);
      }
      _token = data['idToken'];
      _expireTime = DateTime.now().add(
        Duration(
          seconds: int.parse(data['expiresIn']),
        ),
      );
      _UserID = data['localId'];
      notifyListeners();
      autoLogout();

      final canal = await SharedPreferences.getInstance();
      final Authdata = jsonEncode({
        "token": _token,
        "userid": _UserID,
        "expireTime": _expireTime!.toIso8601String(),
      });
      canal.setString('authData', Authdata);
    } catch (error) {
      throw error;
    }
  }

  Future<void> SignUp(String email, String passwords) async {
    return _Authenticatia(email, passwords, 'signUp');
  }

  Future<void> login(String email, String passwords) async {
    return _Authenticatia(email, passwords, 'signInWithPassword');
  }

  Future<bool?> autoLogin() async {
    final canal = await SharedPreferences.getInstance();
    if (!canal.containsKey('authData')) {
      return false;
    }
    final authData =
        (jsonDecode(canal.getString('authData')!) as Map<String, dynamic>);

    final ExpireTime = DateTime.parse(authData['expireTime']);

    //agar expiretime(soat 10:00) hozirgi vaqtdan(10:40) oldinda bulsa
    if (ExpireTime.isBefore(DateTime.now())) {
      //Token muddati tugagan
      return false;
    }
    _UserID = authData['userid'];
    _token = authData['token'];
    _expireTime = ExpireTime;
    autoLogout();

    return true;
  }

  void LogOut() async {
    _UserID = null;
    _expireTime = null;
    _token = null;
    if (autoLogoutTimer != null) {
      autoLogoutTimer!.cancel();
      autoLogoutTimer = null;
    }
    notifyListeners();
    final canal = await SharedPreferences.getInstance();
    canal.clear();
  }

  void autoLogout() {
    if (autoLogoutTimer != null) {
      autoLogoutTimer!.cancel();
      autoLogoutTimer = null;
    }
    final Sparetime = _expireTime!.difference(DateTime.now()).inSeconds;
    autoLogoutTimer = Timer(Duration(seconds: Sparetime), LogOut);
  }
}
