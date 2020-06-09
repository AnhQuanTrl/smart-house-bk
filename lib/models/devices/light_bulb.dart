import 'package:flutter/material.dart';
import 'package:smarthouse/models/devices/device.dart';
import 'package:smarthouse/presentations/device_page/light_bulb_details_page.dart';

class LightBulb extends Device {
  bool mode;
  LightBulb({this.mode, @required String name, @required int id})
      : super(name: name, id: id);

  @override
  Widget buildLeading() {
    return Icon(Icons.lightbulb_outline);
  }

  @override
  Widget buildTitle() {
    return Text(name);
  }

  @override
  Widget buildTrailing() {
    return Icon(
      Icons.brightness_1,
      color: mode ? Colors.deepOrangeAccent : Colors.grey,
    );
  }

  @override
  void onTap(BuildContext context) {
    Navigator.pushNamed(context, LightBulbDetailsPage.routeName, arguments: id);
  }
}
