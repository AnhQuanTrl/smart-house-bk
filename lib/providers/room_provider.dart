import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:smarthouse/models/devices/device.dart';
import 'package:smarthouse/models/room.dart';
import 'package:http/http.dart' as http;
import '../utils/api.dart' as api;
import 'device_provider.dart';

class RoomProvider with ChangeNotifier {
  List<Room> rooms;
  DeviceProvider deviceProvider;

  void updateDeviceProvider(DeviceProvider deviceProvider) {
    this.deviceProvider = deviceProvider;
  }

  void addRoom(Room room) {}

  Future<void> fetch() async {
    rooms = new List<Room>();
    var res = await http.get(api.server + "api/rooms/");
    List<dynamic> roomList = json.decode(res.body);
    print(roomList);
    roomList.forEach((element) {
      Room room = new Room(element['name'], null, id: element['id']);
      room.deviceList =
          populateDevice(List<int>.from(element['devices']), room);
      print(room.deviceList);
      rooms.add(room);
    });
    notifyListeners();
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
