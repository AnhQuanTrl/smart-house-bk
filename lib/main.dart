import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarthouse/providers/device_provider.dart';
import 'package:smarthouse/providers/room_provider.dart';
import 'presentations/home_page/home_page.dart';
import 'presentations/room_page/room_page.dart';
import 'presentations/room_page/room_page.dart';

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
        ChangeNotifierProvider(create: (_) => RoomProvider()),
        ChangeNotifierProvider(create: (_) => DeviceProvider())
      ],
      child: MaterialApp(
      theme: ThemeData(
        textTheme: TextTheme(
          body1: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
        ),
        primaryColor: Colors.blue,
        backgroundColor: Colors.blue[50],
        accentColor: Colors.deepOrangeAccent,
      ),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (settings) {
        if (settings.name == RoomPage.routeName) {
          final room = settings.arguments;
          return MaterialPageRoute(
            builder: (context) {
              return RoomPage(roomId: room);
            },
          );
        }
      },
      initialRoute: "/",
      routes: {
        HomePage.routeName: (context) => HomePage(),
        RoomPage.routeName: (context) => RoomPage(),
      },
    ),);
  }
}
