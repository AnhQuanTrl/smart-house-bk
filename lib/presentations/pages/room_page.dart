import 'package:flutter/material.dart';
import 'package:smarthouse/blocs/room_page_bloc.dart';
import 'package:smarthouse/models/devices/device.dart';
import 'package:smarthouse/presentations/components/device/device_room_page_card.dart';
import 'package:smarthouse/presentations/components/room_info.dart';

class RoomPage extends StatefulWidget {
  static const String routeName = '/room_page';
  final int roomId;

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
      body: Row(
        children: buildRoomPageWidget(bloc),
      ),
    );
  }
}

List<Widget> buildRoomPageWidget(RoomPageBloc bloc)
{
  List<Widget> ret = [];
  ret.add(RoomInfo(bloc: bloc));
  for(Device d in bloc.room.devicesList)
  {
    ret.add(DeviceRoomPageCard(device: d));
  }
  return ret;
}