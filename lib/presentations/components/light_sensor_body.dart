import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarthouse/models/devices/light_sensor.dart';
import 'package:smarthouse/presentations/components/trigger_list.dart';
import 'package:percent_indicator/percent_indicator.dart';

class LightSensorBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LightSensor ls = Provider.of<LightSensor>(context);
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                ls.name,
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            CircularPercentIndicator(
              radius: 200.0,
              lineWidth: 20.0,
              percent: ls.value / 255,
              center: Text(
                "Luminous intensity",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25),
              ),
              progressColor: Theme.of(context).accentColor,
            ),
            Expanded(
              child: TriggerList(),
            ),
          ],
        ),
      ),
    );
  }
}
