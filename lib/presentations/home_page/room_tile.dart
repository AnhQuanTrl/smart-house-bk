import 'package:flutter/material.dart';
import 'package:smarthouse/models/room.dart';

import '../room_page/room_page.dart';

class RoomTile extends StatefulWidget {
  final Room room;
  RoomTile({this.room});
  @override
  _RoomTileState createState() => _RoomTileState();
}

class _RoomTileState extends State<RoomTile> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(widget.room.name),
        onTap: () => Navigator.of(context).pushNamed(RoomPage.routeName),
      ),
    );
  }
}
