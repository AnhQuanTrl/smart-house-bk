import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LivingRoom extends StatefulWidget {
  @override
  _LivingRoomState createState() => _LivingRoomState();
}

class _LivingRoomState extends State<LivingRoom> {
  @override
  Widget build(BuildContext context) {
    List<String> devices = [
      "Lamp",
      "Air Conditioner",
    ];
    return Scaffold(
      // backgroundColor: Colors.grey[900],
      appBar: AppBar(
        // backgroundColor: Colors.grey[850],
        title: Text(
            "Living room",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            )
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0),
        child: Column(
          children: <Widget>[
            ListView(
              shrinkWrap: true,
              children: devices.map((device) => Device(device: device)).toList(),
            )
          ],
        ),
      ),
    );
  }
}

class Device extends StatefulWidget {
  final String device;
  Device({this.device});
  @override
  _DeviceState createState() => _DeviceState();
}

class _DeviceState extends State<Device> {
  bool isSwitched = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
      margin: EdgeInsets.all(5.0),
      height: 50.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            this.widget.device,
            style: TextStyle(

              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
          Switch(
            value: this.isSwitched,
            activeTrackColor: Colors.black,
            activeColor: Colors.grey[100],
            inactiveTrackColor: Colors.black,
            onChanged: (value) {
              setState(() {
                this.isSwitched = value;
              });
            },
          )
        ],
      ),
    );
  }
}

