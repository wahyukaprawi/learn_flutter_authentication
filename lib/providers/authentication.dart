import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Authentication with ChangeNotifier {
  String? _idToken, userId;
  DateTime? _expiryDate;

  String? _tempidToken, tempuserId;
  DateTime? _tempexpiryDate;

  void tempData() {
    _idToken = _tempidToken;
    userId = tempuserId;
    _expiryDate = _tempexpiryDate;
    notifyListeners();
  }

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_idToken != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _expiryDate != null) {
      return _idToken;
    } else {
      return null;
    }
  }

  Future<void> signUp(email, password) async {
    Uri url = Uri.parse(
      "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyCvAJ_6tuko9uf9RNHSRmfiI-AttCryCQw",
    );

    try {
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
      _tempidToken = responseData["idToken"];
      tempuserId = responseData["localId"];
      _tempexpiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData["expiresIn"]),
        ),
      );
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> login(email, password) async {
    Uri url = Uri.parse(
      "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyCvAJ_6tuko9uf9RNHSRmfiI-AttCryCQw",
    );

    try {
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
      _tempidToken = responseData["idToken"];
      tempuserId = responseData["localId"];
      _tempexpiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData["expiresIn"]),
        ),
      );
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
