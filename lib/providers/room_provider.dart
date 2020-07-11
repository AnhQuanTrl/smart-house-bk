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

  Future<void> removeRoom(Room room) async {
    room.deviceList.forEach((element) {
      element.room = null;
    });
    rooms.remove(room);
    notifyListeners();
    var res = await http.delete(api.server + "api/rooms/${room.id}/delete",
        headers: {
          "Authorization": _jwt,
          'Content-type': 'application/json'
        }).timeout(const Duration(seconds: 5));
    if (res.statusCode != 200) {
      throw Exception("Something wrong");
    }
  }

  void removeDevice(Room room, Device device) {
    room.deviceList.remove(device);
    device.room = null;
    notifyListeners();
  }

  void removeDeviceWithoutSetNull(Room room, Device device) {
    room.deviceList.remove(device);
    notifyListeners();
  }

  Room findRoomById(int id) {
    return rooms.firstWhere((element) => element.id == id);
  }

  Future<void> addDeviceToRoom(Room room, Device device) async {
    Map body = {
      'id': room.id,
      'deviceIds': [device.id]
    };
    Room oldRoom = rooms.firstWhere(
        (element) => element.deviceList.contains(device),
        orElse: () => null);
    if (oldRoom != null) {
      oldRoom.deviceList.remove(device);
    }
    room.deviceList.add(device);
    device.room = room;
    notifyListeners();
    var res = await http.patch(api.server + "api/rooms/add-device",
        body: json.encode(body),
        headers: {
          "Authorization": _jwt,
          'Content-type': 'application/json'
        }).timeout(const Duration(seconds: 5));
    print("here");

    if (res.statusCode == 200) {
    } else {
      throw Exception("Something Wrong");
    }
  }

  Future<void> removeDeviceFromRoom(Device device) async {
    Room room = rooms.firstWhere(
        (element) => element.deviceList.contains(device),
        orElse: () => null);
    if (room == null) {
      return;
    }
    Map body = {
      'id': room.id,
      'deviceIds': [device.id]
    };
    removeDevice(room, device);
    var res = await http.patch(api.server + "api/rooms/remove-device",
        body: json.encode(body),
        headers: {
          "Authorization": _jwt,
          'Content-type': 'application/json'
        }).timeout(const Duration(seconds: 5));
    if (res.statusCode == 200) {
    } else {
      throw Exception("Something Wrong");
    }
  }

  Future<void> fetch() async {
    rooms = [];
    var res = await http.get(api.server + "api/rooms/",
        headers: {"Authorization": _jwt}).timeout(const Duration(seconds: 5));
    try {
      print(res.body);
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
    print(deviceIds);
    return deviceIds.map((id) {
      Device device = deviceProvider.findById(id);
      if (device != null) {
        device.room = room;
      }
      return device;
    }).toList();
  }
}
