import 'package:flutter/material.dart';

class LightSensorDetailsPage extends StatelessWidget {
  static const String routeName = "/light-sensor";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(title: Text("Light Sensor"),),
    );
  }
}