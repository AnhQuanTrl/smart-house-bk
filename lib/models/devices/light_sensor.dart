import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smarthouse/models/devices/device.dart';
import 'package:smarthouse/models/trigger.dart';
import 'package:smarthouse/presentations/pages/light_sensor_details_page.dart';
import 'package:http/http.dart' as http;
import '../../utils/api.dart' as api;

class LightSensor extends Device {
  final storage = FlutterSecureStorage();
  int value;
  List<Trigger> triggers = [];
  LightSensor({this.value, @required String name, @required int id})
      : super(name: name, id: id);

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
    Navigator.pushNamed(context, LightSensorDetailsPage.routeName,
        arguments: id);
  }

  Future<void> addTrigger(Map<String, Object> data) async {
    final jwt = await storage.read(key: 'jwt');
    data['sensorName'] = name;
    print(data);
    var body = json.encode(data);
    var res = await http.post(
      api.server + 'api/triggers/setting',
      body: body,
      headers: {"Content-Type": "application/json", "Authorization": jwt},
    );
    if (res.statusCode != 200) {
      print(res.statusCode);
      throw Exception("Some error");
    }
    Map<String, Object> value = json.decode(res.body);
    triggers.add(Trigger(
        id: value['id'],
        triggerValue: value['triggerValue'],
        mode: value['mode'],
        control: data['deviceName']));
    notifyListeners();
  }
}
