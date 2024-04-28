import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Authentication with ChangeNotifier {
  void signUp(email, password) async {
    Uri url = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:signInWithCustomToken?key=AIzaSyCvAJ_6tuko9uf9RNHSRmfiI-AttCryCQw");

    var response = await http.post(
      url,
      body: jsonEncode({
        "email": email,
        "password": password,
        "returnSecureToken": true,
      }),
    );
    // ignore: avoid_print
    print(jsonDecode(response.body));
  }
}
