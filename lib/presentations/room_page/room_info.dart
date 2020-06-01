import 'package:flutter/material.dart';
import 'package:smarthouse/blocs/room_page_bloc.dart';

class RoomInfo extends StatefulWidget {
//  final RoomPageBloc bloc;
//  RoomInfo({this.bloc});
  final int temperature;
  final int humidity;
  final int brightness;
  RoomInfo({this.temperature, this.humidity, this.brightness});
  @override
  _RoomInfoState createState() => _RoomInfoState();
}

class _RoomInfoState extends State<RoomInfo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
      margin: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            widget.temperature.toString(),
          ),
          Column(
            children: <Widget>[
              Text(
                widget.humidity.toString() + "%",
              ),
              Text(
                widget.brightness.toString(),
              ),
            ],
          )
        ],
      ),
    );
  }
}
