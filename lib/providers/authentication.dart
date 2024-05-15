import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Authentication with ChangeNotifier {
  String? _idToken, userId;
  DateTime? _expiryDate;

  String? _tempidToken, tempuserId;
  DateTime? _tempexpiryDate;

  Future<void> tempData() async {
    _idToken = _tempidToken;
    userId = tempuserId;
    _expiryDate = _tempexpiryDate;

    final sharedPref = await SharedPreferences.getInstance();

    final myMapSPref = json.encode({
      'token': _tempidToken,
      'uid': tempuserId,
      'expired': _tempexpiryDate?.toIso8601String()
    });

    sharedPref.setString("authData", myMapSPref);
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
    } catch (error) {
      rethrow;
    }
  }

  void logout() async {
    _idToken = null;
    userId = null;
    _expiryDate = null;

    final pref = await SharedPreferences.getInstance();
    pref.clear();
    notifyListeners();
  }

  Future<bool> autologin() async {
    final pref = await SharedPreferences.getInstance();
    if (!pref.containsKey('authData')) {
      return false;
    }
    final myData =
        json.decode(pref.get('authData') as String) as Map<String, dynamic>;
    final myExpiryDate = DateTime.parse(myData["expired"]);
    if (myExpiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _idToken = myData["token"];
    userId = myData["uid"];
    _expiryDate = myExpiryDate;
    notifyListeners();
    return true;
  }
}
