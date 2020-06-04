import 'package:flutter/material.dart';
import 'package:smarthouse/models/devices/device.dart';
import 'package:http/http.dart' as http;
import 'package:smarthouse/models/devices/light_bulb.dart';
import 'package:smarthouse/models/room.dart';
import 'dart:convert';
import '../utils/api.dart' as api;

import 'package:smarthouse/models/devices/light_sensor.dart';

class DeviceProvider with ChangeNotifier {
  List<Device> unassginedDevices;
  List<Device> assignedDevices = [];

  void fetch() async {
    unassginedDevices = new List<Device>();
    var res = await http.get(api.server + "api/devices/");
    print(res.body);
    List<dynamic> deviceList = json.decode(res.body);
    deviceList.forEach((element) {
      if (element['type'] == 'LB') {
        unassginedDevices.add((new LightBulb(id: element['id'], name: element['name'], mode: element['mode'])));
      } else {
        unassginedDevices.add(new LightSensor(id: element['id'], name: element['name'], value: element['light']));
      }
    });
    notifyListeners();
  }

  Device findById(int id) {
    return unassginedDevices.firstWhere((element) => element.id == id, orElse: null);
  }

}