import 'dart:convert';
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTimer;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String? get userId {
    return _userId;
  }

  String _firebaseApiKey = 'AIzaSyAbbS_HW2t3CAMwuS2n7g_0OpindZ8sxJw';

  Future<void> _authenticateUser(String email, String password, Uri url) async {
    try {
      final response = await http.post(url,
          body: jsonEncode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final responseData = jsonDecode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      _autoLogout();
      notifyListeners();
      final _prefs = await SharedPreferences.getInstance();
      final _userData = jsonEncode({
        'userId': _userId,
        'token': _token,
        'expiryDate': _expiryDate!.toIso8601String(),
      });
      _prefs.setString('userData', _userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String? email, String? password) async {
    final Uri url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_firebaseApiKey');
    if (email != null && password != null) {
      return _authenticateUser(email, password, url);
    }
  }

  Future<void> login(String? email, String? password) async {
    final Uri url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_firebaseApiKey');
    if (email != null && password != null) {
      return _authenticateUser(email, password, url);
    }
  }

  Future<bool> tryAutoLogin() async {
    final _prefs = await SharedPreferences.getInstance();
    if (_prefs.containsKey('userData')) {
      return false;
    }
    final _userData =
        jsonDecode(_prefs.getString('userData')!) as Map<String, Object>;
    final expiryDate = DateTime.parse(_userData['expiryDate'] as String);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = _userData['token'] as String;
    _userId = _userData['userId'] as String;
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();

    return true;
  }

  void logout() {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpire = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpire), logout);
  }
}
