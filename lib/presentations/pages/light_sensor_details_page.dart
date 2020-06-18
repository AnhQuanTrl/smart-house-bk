import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarthouse/models/devices/device.dart';
import 'package:smarthouse/models/devices/light_bulb.dart';
import 'package:smarthouse/models/devices/light_sensor.dart';
import 'package:smarthouse/models/trigger.dart';
import 'package:smarthouse/presentations/components/add_trigger_form.dart';
import 'package:smarthouse/presentations/components/trigger_list.dart';
import 'package:smarthouse/providers/device_provider.dart';

class LightSensorDetailsPage extends StatelessWidget {
  static const String routeName = "/light-sensor";
  final int id;
  const LightSensorDetailsPage({this.id});
  @override
  Widget build(BuildContext context) {
    LightSensor lightSensor =
        Provider.of<DeviceProvider>(context, listen: false).findById(id)
            as LightSensor;
    return ChangeNotifierProvider.value(
      value: lightSensor,
      child: Scaffold(
        appBar: AppBar(
          title: Text(lightSensor.name),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: TriggerList(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) => AddTriggerForm(lightSensor: lightSensor));
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
