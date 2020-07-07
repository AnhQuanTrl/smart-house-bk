import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarthouse/models/devices/light_bulb.dart';

import 'light_bulb_icon.dart';
import 'light_bulb_slider.dart';

class LightBulbInformation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(15.0),
            child: Consumer<LightBulb>(
              builder: (ctx, lb, _) {
                return Text(
                  lb.name,
                  style: Theme.of(context).textTheme.headline3,
                );
              },
            ),
          ),
          SizedBox(
            height: 25,
          ),
          LightBulbIcon(),
          SizedBox(
            height: 100,
          ),
          Padding(padding: EdgeInsets.all(15.0), child: LightBulbSlider()),
        ],
      ),
    );
  }
}
