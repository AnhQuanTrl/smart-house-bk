import 'package:flutter/material.dart';
import 'package:smarthouse/models/devices/device.dart';
import 'package:provider/provider.dart';
import '../../providers/device_provider.dart';

class DeviceTile extends StatelessWidget {
  final Device device;
  final Function dismissed;
  const DeviceTile(this.device, {this.dismissed});
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(device.id),
      onDismissed: (_) {
        if (dismissed != null) dismissed();
        context.read<DeviceProvider>().unregisterDevice(device.name);
      },
      child: ListTile(
        leading: device.buildLeading(),
        title: device.buildTitle(),
        trailing: device.buildTrailing(),
        onTap: () => device.onTap(context),
      ),
    );
  }
}
