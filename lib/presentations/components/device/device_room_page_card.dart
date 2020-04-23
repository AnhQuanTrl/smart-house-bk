import 'package:flutter/material.dart';
import 'package:smarthouse/models/devices/device.dart';
import 'package:smarthouse/models/devices/light.dart';

class DeviceRoomPageCard extends StatefulWidget {
  final Device device;
  DeviceRoomPageCard({this.device});
  @override
  _DeviceRoomPageCardState createState() => _DeviceRoomPageCardState();
}

class _DeviceRoomPageCardState extends State<DeviceRoomPageCard> {
  @override
  Widget build(BuildContext context) {
    String asset;
    dynamic switchableDevice = widget.device as SwitchValue;
    if (widget.device is Light)
    {
      asset = "assets/images/bulb.png";
    }
//    else if (this.widget.device.compareTo("Air conditioner") == 0)
//    {
//      asset = "assets/images/air_conditioning_indoor.png";
//    }
//    else
//    {
//      asset = "assets/images/fan.png";
//    }
    return Container(
      padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
      margin: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Image.asset(asset),
                onPressed: () {},
              ),
              Switch(
                value: switchableDevice.value,
                activeTrackColor: Colors.blue[900],
                activeColor: Colors.grey[100],
                inactiveTrackColor: Colors.grey[400],
                onChanged: widget.device.switchValueOnChange,
              )
            ],
          ),
          Row(
            children: <Widget>[
              Text(
                widget.device.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}