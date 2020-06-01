import 'package:smarthouse/models/devices/device.dart';

class Light implements Device {
  int value;
  String assetDir = "assets/images/bulb.png";
  Light({this.value, this.name, this.id}) : super();

  @override
  int id;

  @override
  String name;

  @override
  Function countValueOnChange;

  @override
  Function switchValueOnChange;
}
