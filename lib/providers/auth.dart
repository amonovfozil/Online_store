import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:online_market/servises/http_exteption.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  DateTime? _SPareToken;
  String? _UserID;

  static const epiKey = 'AIzaSyCTWQZAXcQylRVLMssmfKbP4QD7ZjMwphU';
  bool get isAuth {
    return _token != null;
  }

  String? get UserID {
    return _UserID;
  }

  String? get Token {
    if (_SPareToken != null &&
        _SPareToken!.isAfter(DateTime.now()) &&
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
      _SPareToken = DateTime.now().add(
        Duration(
          seconds: int.parse(data['expiresIn']),
        ),
      );
      _UserID = data['localId'];
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> SignUp(String email, String passwords) async {
    return _Authenticatia(email, passwords, 'signUp');
  }

  Future<void> login(String email, String passwords) async {
    return _Authenticatia(email, passwords, 'signInWithPassword');
  }
}
