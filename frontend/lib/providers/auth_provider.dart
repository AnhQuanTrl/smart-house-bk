import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:smarthouse/exception/authentication_exception.dart';
import '../utils/api.dart' as api;
import 'dart:convert';

class AuthProvider with ChangeNotifier {
  final storage = FlutterSecureStorage();
  String jwt;
  Future<bool> autoLogin() async {
    if (jwt == null) {
      jwt = await storage.read(key: 'jwt') ?? "";
    }
    if (jwt == "") {
      return false;
    }
    var response = await http
        .get(api.server + "api/rooms/", headers: {"Authorization": jwt});
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<void> login(String username, String password) async {
    Map<String, String> authDetail = {
      'username': username,
      'password': password
    };
    var body = json.encode(authDetail);
    try {
      var res = await http.post(api.server + 'api/auth/login',
          headers: {"Content-Type": "application/json"}, body: body);
      if (res.statusCode != 200) {
        throw AuthenticationException(json.decode(res.body)['message']);
      }
      var token = json.decode(res.body);
      String tokenString = "${token['tokenType']} ${token['accessToken']}";
      jwt = tokenString;
      storage.write(key: 'jwt', value: tokenString);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String username, String password) async {
    Map<String, String> authDetail = {
      'username': username,
      'password': password
    };
    var body = json.encode(authDetail);
    try {
      var res = await http.post(api.server + 'api/auth/signup',
          headers: {"Content-Type": "application/json"}, body: body);
      if (res.statusCode != 201) {
        throw AuthenticationException(json.decode(res.body)['message']);
      }
    } catch (error) {
      throw error;
    }
  }
}
