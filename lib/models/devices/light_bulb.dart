
import 'package:flutter/material.dart';

class LightBulb {
  int id;
  String name;
  String assetDir = "assets/images/bulb.png";
  bool mode;

  LightBulb({@required this.id,@required this.name, this.mode = true});
}