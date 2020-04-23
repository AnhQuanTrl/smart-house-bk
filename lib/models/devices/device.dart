







class Device {
  int id;
  String name;
  Function switchValueOnChange;
  Function countValueOnChange;
  Device({this.id, this.name});
}

abstract class Countable {
  int value;
}

class Info {
  int infoValue;
  String type;
}

abstract class SwitchValue {
  int boolValue;
}
