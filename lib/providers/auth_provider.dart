import 'package:flutter/material.dart';
import 'package:smarthouse/services/secure_storage.dart';
import 'package:http/http.dart' as http;
import '../utils/api.dart' as api;
import 'dart:convert';

class AuthProvider with ChangeNotifier {
  final storage = SecureStorage.instance.storage;
  String jwt;
  void init() async {
    jwt = await storage.read(key: 'jwt');
  }

  AuthProvider() {
    init();
  }
  Future<void> attempLogin(String username, String password) async {
    Map<String, String> authDetail = {
      'username': username,
      'password': password
    };
    var body = json.encode(authDetail);
    try {
      var res = await http.post(api.server + 'api/auth/login',
          headers: {"Content-Type": "application/json"}, body: body);
      var token = json.decode(res.body);
      String tokenString = "${token['tokenType']} ${token['accessToken']}";
      jwt = tokenString;
      storage.write(key: 'jwt', value: tokenString);
    } catch (error) {
      throw error;
    }
  }
}
