import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _UserId;

  String _firebaseApiKey = 'AIzaSyAbbS_HW2t3CAMwuS2n7g_0OpindZ8sxJw';

  Future<void> signup(String? email, String? password) async {
    final Uri url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_firebaseApiKey');
    final response = await http.post(url,
        body: jsonEncode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }));
    print(jsonDecode(response.body));
  }
}
