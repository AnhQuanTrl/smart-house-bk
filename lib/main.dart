import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:smarthouse/presentations/device_page/light_bulb_details_page.dart';
import 'package:smarthouse/presentations/device_page/light_sensor_details_page.dart';
import 'package:smarthouse/providers/device_provider.dart';
import 'package:smarthouse/providers/room_provider.dart';
import 'presentations/home_page/home_page.dart';

void main() {
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DeviceProvider()),
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
          HomePage.routeName: (context) => HomePage(),
        },
      ),
    );
  }
}
