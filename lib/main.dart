import 'package:flutter/material.dart';
import 'presentations/home_page/home_page.dart';
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
    return MaterialApp(
      theme: ThemeData(
        textTheme: TextTheme(
          body1: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
        )
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
      },
    );
  }
}
