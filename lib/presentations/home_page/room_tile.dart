import 'package:flutter/material.dart';
import 'package:smarthouse/models/room.dart';
import 'package:smarthouse/presentations/home_page/device_tile.dart';

import '../room_page/room_page.dart';

class RoomTile extends StatelessWidget {
  final Room room;
  const RoomTile(this.room);
  @override
  Widget build(BuildContext context) {
    return room.deviceList.isEmpty ? ListTile(
      title: Text(room.name),
      onTap: () => Navigator.of(context).pushNamed(RoomPage.routeName),
    ) : ExpansionTile(title: Text(room.name), children:
      room.deviceList.map((device) => DeviceTile(device.name)).toList());
  }
}


  
