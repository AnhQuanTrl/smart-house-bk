import 'package:flutter/material.dart';
import 'package:smarthouse/models/devices/device.dart';
import 'package:smarthouse/presentations/components/device_tile.dart';
import 'package:provider/provider.dart';

class DraggableDeviceTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Device device = Provider.of<Device>(context, listen: false);
    return Draggable(
      feedback: Container(
          height: 70, width: 400, child: Card(child: DeviceTile(device))),
      child: DeviceTile(device),
      childWhenDragging: Container(),
      data: device,
    );
  }
}
