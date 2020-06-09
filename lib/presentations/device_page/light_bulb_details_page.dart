import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarthouse/models/devices/light_bulb.dart';
import 'package:smarthouse/providers/device_provider.dart';

class LightBulbDetailsPage extends StatefulWidget {
  static const String routeName = "/light-bulb";
  final int id;

  const LightBulbDetailsPage({this.id});

  @override
  _LightBulbDetailsPageState createState() => _LightBulbDetailsPageState();
}

class _LightBulbDetailsPageState extends State<LightBulbDetailsPage> {
  String title;
  bool mode;
  DeviceProvider deviceProvider;
  @override
  void initState() {
    deviceProvider = Provider.of<DeviceProvider>(context, listen: false);
    title = deviceProvider.findById(widget.id).name;
    mode = (deviceProvider.findById(widget.id) as LightBulb).mode;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: Text("Light Bulb " + title),
        ),
        body: SwitchListTile(
          title: Text("State"),
          value: mode,
          onChanged: (value) async {
            setState(() {
              mode = value;
              try {
                deviceProvider.changeMode(widget.id, mode);
              } catch (error) {
                showDialog(context: context, child: Text(error.toString()));
              }
            });
          },
        ));
  }
}
