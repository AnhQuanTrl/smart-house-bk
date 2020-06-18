import 'package:smarthouse/models/devices/light_bulb.dart';

class Trigger {
  int id;
  String control;
  int triggerValue;
  int releaseValue;
  Trigger({this.id, this.control, this.triggerValue, this.releaseValue});
}
