import 'package:flutter/material.dart';

class DeviceTile extends StatelessWidget {
  final String title;

  const DeviceTile(this.title);
  @override
  Widget build(BuildContext context) {
    return ListTile(title: Text(title),);
  }
}