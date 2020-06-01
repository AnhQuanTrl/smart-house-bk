import 'package:flutter/material.dart';
import 'package:smarthouse/models/room.dart';

class RoomTile extends StatefulWidget {
  final Room room;
  RoomTile({this.room});
  @override
  _RoomTileState createState() => _RoomTileState();
}

class _RoomTileState extends State<RoomTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
      margin: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(widget.room.name),
          Icon(
            Icons.brightness_1,
            color: widget.room.isOn ? Colors.green : Colors.grey,
          ),
        ],
      ),
    );
  }
}
