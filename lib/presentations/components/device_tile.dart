import 'package:flutter/material.dart';
import 'package:smarthouse/models/device.dart';

class DeviceTile extends StatefulWidget {
  final Device device;
  DeviceTile({this.device}): super();
  @override
  _DeviceTileState createState() => _DeviceTileState();
}

class _DeviceTileState extends State<DeviceTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Device')
    );
  }
}