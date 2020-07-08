import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarthouse/models/devices/light_bulb.dart';

class LightBulbSlider extends StatelessWidget {
  static const MAX_LIGHT = 255;
  @override
  Widget build(BuildContext context) {
    LightBulb lb = Provider.of<LightBulb>(context);

    return Slider(
      value: lb.value / MAX_LIGHT,
      onChanged: (x) {},
      onChangeEnd: (newRating) {
        lb.setValue((newRating * MAX_LIGHT).toInt());
      },
      divisions: 10,
    );
  }
}
