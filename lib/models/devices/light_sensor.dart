import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smarthouse/exception/logic_exception.dart';
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

  void changeValue(int newValue) {
    value = newValue;
    notifyListeners();
  }

  Future<void> fetch() async {
    triggers = [];
    final jwt = await storage.read(key: 'jwt');
    var res = await http.get(
      api.server + 'api/triggers/' + id.toString(),
      headers: {"Authorization": jwt},
    );
    var triggerList = json.decode(res.body) as List<dynamic>;
    triggerList.forEach((element) {
      triggers.add(new Trigger(
          id: element['id'],
          control: element['lightBulbName'],
          triggerValue: element['triggerValue'],
          releaseValue: element['releaseValue']));
    });
  }

  Future<void> addTrigger(Map<String, Object> data) async {
    final jwt = await storage.read(key: 'jwt');
    data['sensorName'] = name;
    var body = json.encode(data);
    var res = await http.post(
      api.server + 'api/triggers/setting',
      body: body,
      headers: {"Content-Type": "application/json", "Authorization": jwt},
    );
    if (res.statusCode != 200) {
      if (res.statusCode == 500) {
        throw Exception("Something wrong");
      } else {
        throw LogicException(json.decode(res.body)['message']);
      }
    }
    Map<String, Object> value = json.decode(res.body);
    triggers.add(Trigger(
        id: value['id'],
        triggerValue: value['triggerValue'],
        releaseValue: value['releaseValue'],
        control: data['deviceName']));
    notifyListeners();
  }

  Future<void> deleteTrigger(int id) async {
    final jwt = await storage.read(key: 'jwt');
    var res = await http.delete(
        api.server + 'api/triggers/' + id.toString() + '/delete',
        headers: {"Authorization": jwt});
    if (res.statusCode != 200) {
      throw LogicException("Not Found");
    }
    triggers.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}
