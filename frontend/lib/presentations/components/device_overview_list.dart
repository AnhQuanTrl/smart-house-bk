import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarthouse/models/devices/light_bulb.dart';
import 'package:smarthouse/models/room.dart';
import 'package:smarthouse/providers/device_provider.dart';
import 'package:smarthouse/providers/room_provider.dart';

import 'device_tile.dart';
import 'draggable_device_tile.dart';
import 'heading_tile.dart';
import 'room_tile.dart';

class DeviceOverviewList extends StatelessWidget {
  final Future<void> Function() refresh;

  const DeviceOverviewList({this.refresh});
  @override
  Widget build(BuildContext context) {
    RoomProvider roomProvider = Provider.of<RoomProvider>(context);
    roomProvider.rooms.forEach((element) {});
    DeviceProvider deviceProvider = Provider.of<DeviceProvider>(context);
    return RefreshIndicator(
      onRefresh: refresh,
      child: Column(
        children: <Widget>[
          ListView(
            shrinkWrap: true,
            children: <Widget>[
              HeadingTile("Rooms"),
              ...(roomProvider.rooms ?? <Room>[])
                  .map((room) => RoomTile(room, refresh))
                  .toList(),
              HeadingTile("Unassigned Devices"),
              ...(deviceProvider.devices ?? <LightBulb>[])
                  .where((element) => element.room == null)
                  .map(
                (device) {
                  return ChangeNotifierProvider.value(
                    value: device,
                    child: DraggableDeviceTile(),
                  );
                },
              ).toList(),
            ],
          ),
        ],
      ),
    );
  }
}
