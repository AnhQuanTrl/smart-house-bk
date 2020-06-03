
import 'package:flutter/material.dart';

class LightSensor {
  int id;
  String name;
  int value;
  String assetDir =  "assets/images/fan.png";
  LightSensor({this.value, @required this.name, @required this.id});
}
