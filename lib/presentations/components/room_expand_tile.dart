import "package:flutter/material.dart";
import 'package:smarthouse/models/device.dart';
import 'package:smarthouse/models/room.dart';

import 'device_tile.dart';

class RoomExpandTile extends StatelessWidget {
  final Room room;

  const RoomExpandTile({Key key, this.room}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(room.name),
      children: buildDeviceListTile(),
      initiallyExpanded: true,
    );
  }

  List<Widget> buildDeviceListTile() {
    List<Widget> devicesTiles = [];
    for (Device d in room.devicesList) {
      devicesTiles.add(DeviceTile(device: d));
    }
    return devicesTiles;
  }
}
