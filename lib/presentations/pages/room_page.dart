import 'package:flutter/material.dart';
import 'package:smarthouse/models/room.dart';

class RoomPage extends StatefulWidget {
  static const String routeName = '/room_page';
  final Room room;

  const RoomPage({Key key, this.room}) : super(key: key);

  @override
  RoomPageState createState() => RoomPageState();
}

class RoomPageState extends State<RoomPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}