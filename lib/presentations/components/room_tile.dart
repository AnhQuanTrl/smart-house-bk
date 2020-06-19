import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarthouse/models/devices/light_sensor.dart';
import 'package:smarthouse/models/room.dart';

import 'device_tile.dart';

class RoomTile extends StatelessWidget {
  final Room room;
  const RoomTile(this.room);
  @override
  Widget build(BuildContext context) {
    return room.deviceList.isEmpty
        ? ListTile(
            leading: Icon(Icons.room),
            title: Text(room.name),
            //onTap: () => Navigator.of(context).pushNamed(RoomPage.routeName),
          )
        : ExpansionTile(
            leading: Icon(Icons.room),
            title: Text(room.name),
            children: room.deviceList
                .map((device) => ChangeNotifierProvider.value(
                    value: device, child: DeviceTile()))
                .toList());
  }
}
