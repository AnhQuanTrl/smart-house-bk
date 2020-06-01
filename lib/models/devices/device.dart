class Device {
  int id;
  String name;
  String assetDir;
  int value;
  Function switchValueOnChange;
  Function countValueOnChange;
  Device({this.id, this.name});
}

class Info {
  int infoValue;
  String type;
}
