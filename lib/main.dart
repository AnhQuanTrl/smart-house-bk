import 'package:flutter/material.dart';
import 'package:smarthouse/pages/living_room.art';

import 'presentations/pages/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        HomePage.routeName: (context) => HomePage(),
      },
    );
  }
}
