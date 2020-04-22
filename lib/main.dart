import 'package:flutter/material.dart';
import 'presentations/pages/home_page.dart';
import 'presentations/pages/room_page.dart';

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
