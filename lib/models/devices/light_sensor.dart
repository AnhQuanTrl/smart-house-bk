
import 'package:flutter/material.dart';
import 'package:smarthouse/models/devices/device.dart';
import 'package:smarthouse/presentations/device_page/light_sensor_details_page.dart';

class LightSensor extends Device{
  int value;
  LightSensor({this.value, @required String name, @required int id}): super(name: name, id: id);

  @override
  Widget buildLeading() {
    return Icon(Icons.wb_sunny);
  }

  @override
  Widget buildTitle() {
    return Text(name);
  }

  @override
  Widget buildTrailing() {
    return Text(value.toString());
  }

  @override
  void onTap(BuildContext context) {
    Navigator.pushNamed(context, LightSensorDetailsPage.routeName);
  }
}
