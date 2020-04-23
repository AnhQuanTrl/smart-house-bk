import 'package:smarthouse/models/devices/device.dart';

class Light implements Device {
  bool value;
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
