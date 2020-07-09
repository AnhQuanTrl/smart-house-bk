import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarthouse/models/devices/device.dart';
import 'package:smarthouse/models/devices/light_sensor.dart';
import 'package:smarthouse/models/room.dart';
import 'package:smarthouse/providers/room_provider.dart';

import 'device_tile.dart';

class RoomTile extends StatelessWidget {
  final Room room;
  final Function refresh;
  const RoomTile(this.room, this.refresh);
  @override
  Widget build(BuildContext context) {
    RoomProvider roomProvider = Provider.of<RoomProvider>(context);
    return DragTarget<Device>(
        onAccept: (data) async {
          await roomProvider.addDeviceToRoom(room, data);
          refresh();
        },
        onWillAccept: (_) => true,
        builder: (context, candidate, reject) => room.deviceList.isEmpty
            ? ListTile(
                leading: Icon(Icons.room),
                title: Text(room.name),
                //onTap: () => Navigator.of(context).pushNamed(RoomPage.routeName),
              )
            : ExpansionTile(
                leading: Icon(Icons.room),
                title: Text(room.name),
                children: (room.deviceList ?? [])
                    .map((device) => ChangeNotifierProvider.value(
                        value: device,
                        child: DeviceTile(device,
                            dismissed: () =>
                                roomProvider.removeDevice(room, device))))
                    .toList()));
  }
}
