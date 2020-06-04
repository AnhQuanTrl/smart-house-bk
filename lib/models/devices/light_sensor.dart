
import 'package:flutter/material.dart';
import 'package:smarthouse/models/devices/device.dart';

class LightSensor extends Device{
  int value;
  LightSensor({this.value, @required String name, @required int id}): super(name: name, id: id, assetDir: "assets/images/fan.png");
}
