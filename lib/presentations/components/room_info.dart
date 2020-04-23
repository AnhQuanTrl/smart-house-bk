import 'package:flutter/material.dart';
import 'package:smarthouse/blocs/room_page_bloc.dart';

class RoomInfo extends StatefulWidget {
  final RoomPageBloc bloc;
  RoomInfo({this.bloc});
  @override
  _RoomInfoState createState() => _RoomInfoState();
}

class _RoomInfoState extends State<RoomInfo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Container(),
          Column(
            children: <Widget>[
              Container(),
              Container(),
            ],
          )
        ],
      ),
    );
  }
}
