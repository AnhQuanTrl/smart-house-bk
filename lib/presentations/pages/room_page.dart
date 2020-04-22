import 'package:flutter/material.dart';
import 'package:smarthouse/blocs/room_page_bloc.dart';

class RoomPage extends StatefulWidget {
  static const String routeName = '/room_page';
  int roomId;

  RoomPage({Key key, this.roomId}) : super(key: key);

  @override
  RoomPageState createState() => RoomPageState();
}

class RoomPageState extends State<RoomPage> {
  RoomPageBloc bloc;
  @override
  void initState() {
    bloc = RoomPageBloc(roomId: widget.roomId);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(bloc.room.name),),
    );
  }
}