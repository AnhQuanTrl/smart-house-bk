import 'package:smarthouse/models/devices/device.dart';

class Fan implements Device {
  int value;
  String assetDir = "assets/images/fan.png";
  Fan({this.value, this.name, this.id}) : super();

  @override
  int id;

  @override
  String name;

  @override
  Function countValueOnChange;

  @override
  Function switchValueOnChange;
}