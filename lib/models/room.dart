
import 'package:smarthouse/models/devices/device.dart';


class Room {
  int id;
  Room(this.name, this.devicesList, {this.id});
  String name;
  List<Device> devicesList;
}