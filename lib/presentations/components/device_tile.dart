import 'package:flutter/material.dart';
import 'package:smarthouse/models/devices/device.dart';
import 'package:provider/provider.dart';
import '../../providers/device_provider.dart';

class DeviceTile extends StatelessWidget {
  const DeviceTile();
  @override
  Widget build(BuildContext context) {
    Device device = context.watch<Device>();
    return Dismissible(
      key: ValueKey(device.id),
      onDismissed: (_) =>
          context.read<DeviceProvider>().unregisterDevice(device.name),
      child: ListTile(
        leading: device.buildLeading(),
        title: device.buildTitle(),
        trailing: device.buildTrailing(),
        onTap: () => device.onTap(context),
      ),
    );
  }
}
