import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:smarthouse/presentations/pages/auth_page.dart';
import 'package:smarthouse/presentations/pages/device_overview_page.dart';
import 'package:smarthouse/presentations/pages/light_bulb_details_page.dart';
import 'package:smarthouse/presentations/pages/light_sensor_details_page.dart';
import 'package:smarthouse/providers/auth_provider.dart';
import 'package:http/http.dart' as http;
import 'package:smarthouse/providers/dialog_provider.dart';
import 'package:smarthouse/providers/web_socket_provider.dart';
import './utils/api.dart' as api;
import 'package:smarthouse/providers/device_provider.dart';
import 'package:smarthouse/providers/room_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  String initialRoute = AuthPage.routeName;
  if (prefs.getBool('first_run') ?? true) {
    FlutterSecureStorage storage = FlutterSecureStorage();

    await storage.deleteAll();

    prefs.setBool('first_run', false);
  } else {
    final storage = FlutterSecureStorage();
    String jwt = await storage.read(key: 'jwt');
    if (jwt != null) {
      try {
        var response = await http
            .get(api.server + "api/rooms/", headers: {"Authorization": jwt});
        if (response.statusCode == 200) {
          initialRoute = DeviceOverviewPage.routeName;
        }
      } catch (e) {}
    }
  }
  print(initialRoute);
  return runApp(MyApp(
    initialRoute: initialRoute,
  ));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({Key key, this.initialRoute}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<DialogProvider>(
          create: (context) => DialogProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => WebSocketProvider(),
        ),
        ChangeNotifierProxyProvider<WebSocketProvider, DeviceProvider>(
          create: (_) => DeviceProvider(),
          update: (_, value, previous) => previous..update(value),
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
              headline6:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              bodyText2:
                  TextStyle(fontSize: 20, fontWeight: FontWeight.normal)),
          primaryColor: Colors.cyanAccent,
          backgroundColor: Colors.white,
          accentColor: Colors.orange,
        ),
        debugShowCheckedModeBanner: false,
        onGenerateRoute: (settings) {
          if (settings.name == LightBulbDetailsPage.routeName) {
            final lightBulbId = settings.arguments as int;
            return MaterialPageRoute(
              builder: (context) {
                return LightBulbDetailsPage(id: lightBulbId);
              },
            );
          } else if (settings.name == LightSensorDetailsPage.routeName) {
            final lightSensorId = settings.arguments as int;
            return MaterialPageRoute(
              builder: (context) {
                return LightSensorDetailsPage(id: lightSensorId);
              },
            );
          }
        },
        initialRoute: initialRoute,
        routes: {
          DeviceOverviewPage.routeName: (context) => DeviceOverviewPage(),
          AuthPage.routeName: (context) => AuthPage(),
        },
      ),
    );
  }
}
