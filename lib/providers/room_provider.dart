import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smarthouse/models/devices/device.dart';
import 'package:smarthouse/models/room.dart';
import 'package:http/http.dart' as http;
import '../utils/api.dart' as api;
import 'device_provider.dart';

class RoomProvider with ChangeNotifier {
  List<Room> rooms = [];
  DeviceProvider deviceProvider;
  String _jwt;
  void setJwt(String token) {
    _jwt = token;
  }

  void updateDeviceProvider(DeviceProvider deviceProvider) {
    this.deviceProvider = deviceProvider;
  }

  Future addRoom(Room room) async {
    Map body = {'name': room.name};
    var res = await http.post(api.server + "api/rooms/create",
        body: json.encode(body),
        headers: {
          "Authorization": _jwt,
          'Content-type': 'application/json'
        }).timeout(const Duration(seconds: 5));

    if (res.statusCode == 200) {
      rooms.add(room);
      notifyListeners();
    } else {
      var e = (res.statusCode);
      throw ('error on addRoom' + e.toString());
    }
  }

  Future addDeviceToRoom(Room room, Device device) async {
    Map body = {
      'id': room.id,
      'deviceIds': [device.id]
    };
    var res = await http.patch(api.server + "api/add-device",
        body: json.encode(body),
        headers: {
          "Authorization": _jwt,
          'Content-type': 'application/json'
        }).timeout(const Duration(seconds: 5));
    room.deviceList.add(device);
  }

  Future<void> fetch() async {
    rooms = [];
    var res = await http.get(api.server + "api/rooms/",
        headers: {"Authorization": _jwt}).timeout(const Duration(seconds: 5));
    try {
      List<dynamic> roomList = json.decode(res.body);
      roomList.forEach((element) {
        Room room = new Room(element['name'], null, id: element['id']);
        room.deviceList =
            populateDevice(List<int>.from(element['devices']), room);
        print(room.deviceList);
        rooms.add(room);
      });
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  List<Device> populateDevice(List<int> deviceIds, Room room) {
    return deviceIds.map((id) {
      Device device = deviceProvider.findById(id);
      print(deviceProvider.devices);
      if (device != null) {
        device.room = room;
      }
      return device;
    }).toList();
  }
}
