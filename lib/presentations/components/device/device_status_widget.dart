import 'package:flutter/material.dart';
import 'package:smarthouse/models/devices/device.dart';

class DeviceStatusWidget extends StatefulWidget {
  Device device;

  DeviceStatusWidget(this.device);

  @override
  _DeviceStatusWidgetState createState() => _DeviceStatusWidgetState();
}

class _DeviceStatusWidgetState extends State<DeviceStatusWidget> {
  List<Widget> buildListItem() {
    List<Widget> list = [];
    list.add(
      Text(widget.device.name),
    );
    if (widget.device is Countable) {
      dynamic device2 = widget.device as Countable;
      list.add(Container(
        child: Row(
          children: <Widget>[Text('Status'), Text(device2.infoValue)],
        ),
      ));
    }
    if (widget.device is Countable) {
      dynamic device2 = widget.device as Countable;
      list.add(Container(
        child: Row(
          children: <Widget>[Text('Current value'), Text(device2.value)],
        ),
      ));
    }
    if (widget.device is SwitchValue) {
      dynamic device2 = widget.device as SwitchValue;
      list.add(Container(
        child: Row(
          children: <Widget>[
            Text('Value'),
            Switch(value: device2.boolValue, onChanged: widget.device.switchValueOnChange)
          ],
        ),
      ));
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: buildListItem(),
      ),
    );
  }
}
