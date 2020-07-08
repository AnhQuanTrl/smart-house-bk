import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smarthouse/exception/authentication_exception.dart';
import 'package:smarthouse/models/devices/device.dart';
import 'package:http/http.dart' as http;
import 'package:smarthouse/models/devices/light_bulb.dart';
import 'package:smarthouse/providers/web_socket_provider.dart';
import 'dart:convert';
import '../utils/api.dart' as api;
import 'package:smarthouse/models/devices/light_sensor.dart';

class DeviceProvider with ChangeNotifier {
  List<Device> devices = [];
  final storage = FlutterSecureStorage();
  String _jwt;
  void update(WebSocketProvider webSocketProvider) {
    webSocketProvider.newDevices.forEach((element) {
      var tmp =
          devices.firstWhere((obj) => obj.id == element.id, orElse: () => null);
      if (tmp != null) {
        if (tmp is LightSensor) {
          tmp.value = (element as LightSensor).value;
        } else if (tmp is LightBulb) {
          // print(tmp.value);
          // print((element as LightBulb).value);
          if (tmp.value == (element as LightBulb).value) {
            return;
          }
          tmp.value = (element as LightBulb).value;
          tmp.notifyListeners();
        }
      } else {
        devices.add(element);
      }
    });
    webSocketProvider.newDevices = [];
    notifyListeners();
  }

  void setJwt(String token) {
    _jwt = token;
  }

  Future<void> fetch() async {
    devices = [];
    try {
      var res = await http.get(api.server + "api/devices/",
          headers: {"Authorization": _jwt}).timeout(const Duration(seconds: 5));
      if (res.statusCode != 200) {
        throw AuthenticationException("Not Authorized");
      }
      List<dynamic> deviceList = json.decode(res.body);
      deviceList.forEach((element) {
        if (element['type'] == 'LB') {
          devices.add((new LightBulb(
              id: element['id'],
              name: element['name'],
              value: element['value'])));
        } else {
          devices.add(new LightSensor(
              id: element['id'],
              name: element['name'],
              value: element['light']));
        }
        notifyListeners();
      });
    } catch (e) {
      throw e;
    }
  }

  Device findById(int id) {
    return devices.firstWhere((element) => element.id == id,
        orElse: () => null);
  }

  Future<void> registerDevice(String deviceId) async {
    Map<String, String> map = {"name": deviceId};
    String body = json.encode(map);
    var res = await http.post(api.server + 'api/users/device_register',
        body: body,
        headers: {"Content-Type": "application/json", "Authorization": _jwt});
    if (res.statusCode != 200) {
      if (res.statusCode == 404) {
        throw Exception("Device not found");
      } else {
        throw Exception("Something wrong");
      }
    }
  }

  Future<void> unregisterDevice(String deviceId) async {
    Map<String, String> map = {"name": deviceId};
    String body = json.encode(map);
    var res = await http.post(api.server + 'api/users/device_unregister',
        body: body,
        headers: {"Content-Type": "application/json", "Authorization": _jwt});
    if (res.statusCode != 200) {
      if (res.statusCode == 404) {
        throw Exception("Device nout found");
      } else {
        throw Exception("Something wrong");
      }
    }
  }
}
