import 'package:smarthouse/models/devices/device.dart';
import 'dart:convert';

class Room {
  int id;
  Room(this.name, this.deviceList, {this.id});
  String name;
  List<Device> deviceList;

  factory Room.fromJson(String source) {
    Map value = json.decode(source);
    List<Device> deviceList = [];
    for (var id in value['deviceList']) deviceList.add(Device(id: id));
    return Room(value['name'], deviceList, id: value['id']);
  }

  factory Room.fromMap(Map value) {
    List<Device> deviceList = [];
    for (var id in value['devices']) deviceList.add(Device(id: id));
    return Room(value['name'], deviceList, id: value['id']);
  }

  toJson(){
    Map map = Map();
    map['id'] = id;
    map['name'] = name;
    return json.encode(map);
  }
}
