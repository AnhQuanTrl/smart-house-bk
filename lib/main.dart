import 'package:flutter/material.dart';
import 'package:smarthouse/pages/living_room.dart';

void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  initialRoute: "/living_room",
  routes: {
    "/living_room": (context) => LivingRoom(),
  },
));
