import 'package:flutter/material.dart';
import 'package:smarthouse/models/devices/device.dart';
import 'package:smarthouse/presentations/components/device_tile.dart';
import 'package:provider/provider.dart';
import 'package:smarthouse/providers/room_provider.dart';

class DraggableDeviceTile extends StatelessWidget {
  final Function dismissed;

  const DraggableDeviceTile({Key key, this.dismissed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Device device = Provider.of<Device>(context, listen: false);
    return Draggable(
      onDragEnd: (details) async {
        if (!details.wasAccepted) {
          await Provider.of<RoomProvider>(context, listen: false)
              .removeDeviceFromRoom(device);
        }
      },
      feedback: Container(
          height: 70,
          width: 400,
          child: Card(
              child: DeviceTile(
            device,
          ))),
      child: DeviceTile(
        device,
        dismissed: dismissed,
      ),
      childWhenDragging: Container(),
      data: device,
    );
  }
}
