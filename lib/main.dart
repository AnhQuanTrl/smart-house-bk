import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:smarthouse/presentations/pages/auth_page.dart';
import 'package:smarthouse/presentations/pages/device_overview_page.dart';
import 'package:smarthouse/presentations/pages/home_page.dart';
import 'package:smarthouse/presentations/pages/light_bulb_details_page.dart';
import 'package:smarthouse/providers/auth_provider.dart';

import 'package:smarthouse/providers/device_provider.dart';
import 'package:smarthouse/providers/room_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  return runApp(MyApp());
}

void init() async {
  final prefs = await SharedPreferences.getInstance();
  if (prefs.getBool('first_run') ?? true) {
    FlutterSecureStorage storage = FlutterSecureStorage();

    await storage.deleteAll();

    prefs.setBool('first_run', false);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    init();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => DeviceProvider(),
        ),
        ChangeNotifierProxyProvider<DeviceProvider, RoomProvider>(
          create: (_) => RoomProvider(),
          update: (_, deviceProvider, previous) =>
              previous..updateDeviceProvider(deviceProvider),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          textTheme: TextTheme(
              headline3: TextStyle(fontWeight: FontWeight.bold),
              bodyText2:
                  TextStyle(fontSize: 20, fontWeight: FontWeight.normal)),
          primaryColor: Colors.lightBlue,
          backgroundColor: Colors.lightBlue[50],
          accentColor: Colors.deepOrangeAccent,
        ),
        debugShowCheckedModeBanner: false,
        onGenerateRoute: (settings) {
          if (settings.name == LightBulbDetailsPage.routeName) {
            final lightBulbId = settings.arguments as int;
            print(lightBulbId);
            return MaterialPageRoute(
              builder: (context) {
                return LightBulbDetailsPage(id: lightBulbId);
              },
            );
          }
        },
        initialRoute: "/",
        routes: {
          DeviceOverviewPage.routeName: (context) => DeviceOverviewPage(),
          HomePage.routeName: (context) => HomePage(),
          AuthPage.routeName: (context) => AuthPage()
        },
      ),
    );
  }
}
