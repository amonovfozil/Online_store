import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier {
  String? token;
  DateTime? SPareToken;
  String? UserID;

  static const epiKey = 'AIzaSyCTWQZAXcQylRVLMssmfKbP4QD7ZjMwphU';

  Future<void> SignUp(String email, String password) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$epiKey');
    try {
      final respons = await http.post(
        url,
        body: json.encode(
          {
            "email": email,
            "password": password,
            "returnSecureToken": true,
          },
        ),
      );
      print(jsonDecode(respons.body));
    } catch (error) {
      print(error);
    }
  }
}
