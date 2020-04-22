import "package:flutter/material.dart";
import 'package:smarthouse/models/devices/device.dart';

import 'package:smarthouse/models/room.dart';
import 'package:smarthouse/presentations/pages/room_page.dart';

import 'device_tile.dart';

class RoomExpandTile extends StatelessWidget {
  final Room room;

  const RoomExpandTile({Key key, this.room}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: GestureDetector(
          child: Text(room.name),
          onTap: () {
            Navigator.of(context)
                .pushNamed(RoomPage.routeName, arguments: room.id);
          }),
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
