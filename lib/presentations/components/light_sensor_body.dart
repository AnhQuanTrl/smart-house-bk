import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarthouse/models/devices/light_sensor.dart';
import 'package:smarthouse/presentations/components/trigger_list.dart';

class LightSensorBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LightSensor ls = Provider.of<LightSensor>(context);
    print(ls);
    return Center(
      child: Column(
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
          Expanded(
            child: Card(
              elevation: 20.0,
              margin: EdgeInsets.all(15),
              child: TriggerList(),
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
