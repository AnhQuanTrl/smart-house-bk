import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarthouse/models/devices/light_sensor.dart';
import 'package:smarthouse/models/trigger.dart';

class TriggerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LightSensor lightSensor = Provider.of<LightSensor>(context);
    List<Trigger> triggers = lightSensor.triggers;
    return ListView.builder(
      itemCount: triggers.length,
      itemBuilder: (_, i) => ListTile(
        trailing: triggers[i].mode
            ? Icon(Icons.arrow_upward)
            : Icon(Icons.arrow_downward),
        title: Text(triggers[i].control),
        leading: CircleAvatar(
          child: Text(triggers[i].triggerValue.toString()),
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}
