import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarthouse/models/devices/device.dart';
import 'package:smarthouse/models/room.dart';
import 'package:smarthouse/providers/room_provider.dart';

import 'draggable_device_tile.dart';

class RoomTile extends StatelessWidget {
  final Room room;
  final Function refresh;
  const RoomTile(this.room, this.refresh);
  @override
  Widget build(BuildContext context) {
    RoomProvider roomProvider =
        Provider.of<RoomProvider>(context, listen: false);
    // Room room = roomProvider.findRoomById(roomId);
    return DragTarget<Device>(
        onAccept: (data) async {
          try {
            await roomProvider.addDeviceToRoom(room, data);
          } catch (e) {
            refresh();
          }
        },
        onWillAccept: (data) {
          if (room.deviceList.contains(data)) {
            return false;
          } else {
            return true;
          }
        },
        builder: (context, candidate, reject) =>
            // room.deviceList.isEmpty
            //     ? ListTile(
            //         leading: Icon(Icons.room),
            //         title: Text(room.name),
            //         //onTap: () => Navigator.of(context).pushNamed(RoomPage.routeName),
            //       )
            ExpansionTile(
                leading: Icon(Icons.room),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(room.name),
                    IconButton(
                      icon: Icon(Icons.clear),
                      color: Colors.grey[600],
                      onPressed: () {
                        roomProvider.removeRoom(room);
                      },
                    )
                  ],
                ),
                children: (room.deviceList ?? [])
                    .map((device) => ChangeNotifierProvider.value(
                        value: device,
                        child: DraggableDeviceTile(
                            dismissed: () => roomProvider
                                .removeDeviceWithoutSetNull(room, device))))
                    .toList()));
  }
}
