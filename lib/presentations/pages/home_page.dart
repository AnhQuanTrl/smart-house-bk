import 'package:flutter/material.dart';
import 'package:smarthouse/presentations/pages/device_overview_page.dart';
import 'package:smarthouse/services/secure_storage.dart';
import 'package:http/http.dart' as http;
import 'auth_page.dart';
import '../../utils/api.dart' as api;

class HomePage extends StatelessWidget {
  static const String routeName = "/";
  final storage = SecureStorage.instance.storage;

  Future<bool> get isValidToken async {
    var token = await storage.read(key: "jwt");
    if (token == null) {
      return false;
    }
    var response = await http
        .get(api.server + "api/rooms/", headers: {"Authorization": token});
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: isValidToken,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.data == false) {
          return AuthPage();
        }
        return DeviceOverviewPage();
      },
    );
  }
}
