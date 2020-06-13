import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarthouse/presentations/pages/device_overview_page.dart';
import 'package:smarthouse/providers/auth_provider.dart';
import 'auth_page.dart';

class HomePage extends StatelessWidget {
  static const String routeName = "/";

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<AuthProvider>(context, listen: false).autoLogin(),
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
