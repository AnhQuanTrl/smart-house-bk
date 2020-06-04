
import 'package:flutter/material.dart';
import 'package:smarthouse/models/devices/device.dart';

class LightBulb extends Device {
  bool mode;
  LightBulb({this.mode, @required String name, @required int id}): super(name: name, id: id, assetDir: "assets/images/bulb.png");

}