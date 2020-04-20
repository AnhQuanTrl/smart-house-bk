
import 'package:smarthouse/models/device.dart';

class Room {
  Room(this.name, this.devicesList);
  String name;
  List<Device> devicesList;
}