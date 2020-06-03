import 'package:flutter/material.dart';
import 'package:smarthouse/models/devices/device.dart';
import 'package:http/http.dart' as http;
import 'package:smarthouse/models/devices/light_bulb.dart';
import 'dart:convert';

import 'package:smarthouse/models/devices/light_sensor.dart';

class DeviceProvider with ChangeNotifier {
  List<LightBulb> devices;
  

  void fetch() async {
    devices = new List<LightBulb>();
    var res = await http.get("http://10.0.128.151:8080/api/devices/");
    print(res.body);
    List<dynamic> deviceList = json.decode(res.body);
    deviceList.forEach((element) {
      if (element['type'] == 'LB') {
        devices.add(new LightBulb(id: element['id'], name: element['name'], mode: element['mode']));
      }
    });
    notifyListeners();
  }
}