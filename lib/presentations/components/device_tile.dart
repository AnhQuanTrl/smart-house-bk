import 'package:flutter/material.dart';
import 'package:smarthouse/models/devices/device.dart';

class DeviceTile extends StatelessWidget {
  final Device device;

  const DeviceTile(this.device);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: device.buildLeading(),
      title: device.buildTitle(),
      trailing: device.buildTrailing(),
      onTap: () => device.onTap(context),
    );
  }
}
