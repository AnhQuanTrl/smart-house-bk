import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smarthouse/models/devices/device.dart';
import 'package:http/http.dart' as http;
import 'package:smarthouse/models/devices/light_bulb.dart';
import 'package:smarthouse/services/secure_storage.dart';
import 'dart:convert';
import '../utils/api.dart' as api;
import 'package:smarthouse/models/devices/light_sensor.dart';

class DeviceProvider with ChangeNotifier {
  List<Device> devices;
  final storage = FlutterSecureStorage();

  Future<void> fetch() async {
    devices = new List<Device>();
    try {
      var jwt = await storage.read(key: 'jwt');
      var res = await http
          .get(api.server + "api/devices/", headers: {"Authorization": jwt});
      List<dynamic> deviceList = json.decode(res.body);
      deviceList.forEach((element) {
        if (element['type'] == 'LB') {
          devices.add((new LightBulb(
              id: element['id'],
              name: element['name'],
              mode: element['mode'])));
        } else {
          devices.add(new LightSensor(
              id: element['id'],
              name: element['name'],
              value: element['light']));
        }
        notifyListeners();
      });
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> changeMode(int id, bool mode) async {
    Map<String, Object> map = {"id": id, "mode": mode};
    String body = json.encode(map);
    print(body);
    var res = await http.post(api.server + "api/devices/control",
        body: body, headers: {"Content-Type": "application/json"});
    print(res.statusCode);
    if (res.statusCode != 200) {
      throw Exception("Network error");
    }
  }

  Device findById(int id) {
    return devices.firstWhere((element) => element.id == id,
        orElse: () => null);
  }
}
