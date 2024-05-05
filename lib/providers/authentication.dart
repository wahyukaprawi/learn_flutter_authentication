import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Authentication with ChangeNotifier {
  Future<void> signUp(email, password) async {
    Uri url = Uri.parse(
      "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyCvAJ_6tuko9uf9RNHSRmfiI-AttCryCQw",
    );

    try{
      var response = await http.post(
      url,
      body: jsonEncode({
        "email": email,
        "password": password,
        "returnSecureToken": true,
      }),
    );
      var responseData = jsonDecode(response.body);

      if (responseData["error"] != null) {
        throw responseData["error"]["message"];
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> login(email, password) async {
    Uri url = Uri.parse(
      "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyCvAJ_6tuko9uf9RNHSRmfiI-AttCryCQw",
    );

    try{
      var response = await http.post(
      url,
      body: jsonEncode({
        "email": email,
        "password": password,
        "returnSecureToken": true,
      }),
    );
      var responseData = jsonDecode(response.body);

      if (responseData["error"] != null) {
        throw responseData["error"]["message"];
      }
    } catch (error) {
      rethrow;
    }
  }
}

