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

  void fetch() async {
    rooms = new List<Room>();
    var res = await http.get(api.server + "api/rooms/");
    List<dynamic> roomList = json.decode(res.body);
    print(roomList);
    roomList.forEach((element) {
      rooms.add(new Room(
          element['name'], populateDevice(List<int>.from(element['devices'])),
          id: element['id']));
    });
    notifyListeners();
  }

  List<Device> populateDevice(List<int> deviceIds) {
    return deviceIds.map((id) {
      Device device = deviceProvider.findById(id);
      if (device != null) {
        deviceProvider.assignedDevices.add(device);
        deviceProvider.unassginedDevices.remove(device);
      }
      return device;
    }).toList();
  }
}
