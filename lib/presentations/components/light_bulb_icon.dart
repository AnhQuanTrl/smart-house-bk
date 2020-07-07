import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarthouse/models/devices/light_bulb.dart';

class LightBulbIcon extends StatelessWidget {
  Color getColor(int value) {
    if (value > 200) {
      return Colors.yellow[900];
    }
    if (value > 150) {
      return Colors.yellow[700];
    }
    if (value > 100) {
      return Colors.yellow[500];
    }
    if (value > 50) {
      return Colors.yellow[400];
    }
    if (value > 0) {
      return Colors.yellow[300];
    }
    return Colors.grey[300];
  }

  @override
  Widget build(BuildContext context) {
    LightBulb lb = Provider.of<LightBulb>(context);
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: Icon(
        Icons.lightbulb_outline,
        color: getColor(lb.value),
        size: 56,
      ),
    );
  }
}
