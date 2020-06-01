import 'package:smarthouse/models/devices/device.dart';

class AirConditioner implements Device {
  int value;
  int savedValue;
  String assetDir = "assets/images/air_conditioner.png";
  AirConditioner({this.value, this.name, this.id}) : super();

  @override
  int id;

  @override
  String name;

  @override
  Function countValueOnChange;

  @override
  Function switchValueOnChange;
}