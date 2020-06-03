import 'package:flutter/material.dart';
import 'package:smarthouse/blocs/room_page_bloc.dart';
import 'package:smarthouse/models/devices/device.dart';
import 'package:smarthouse/presentations/room_page/device_tile.dart';
import 'package:smarthouse/presentations/room_page/room_info.dart';


class RoomPage extends StatefulWidget {
  static const String routeName = '/room_page';
  final int roomId;

  RoomPage({Key key, this.roomId}) : super(key: key);

  @override
  RoomPageState createState() => RoomPageState();
}

class RoomPageState extends State<RoomPage> {
//  RoomPageBloc bloc;
  @override
  void initState() {
//    bloc = RoomPageBloc(roomId: widget.roomId);
//    bloc.fetch();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
//      appBar: AppBar(title: Text(bloc.room.name),),
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text("Living Room"),),
      body: ListView(
//        children: buildRoomPageWidget(bloc),
          children: buildRoomPageWidget(),
      ),
    );
  }
}

//List<Widget> buildRoomPageWidget(RoomPageBloc bloc)
List<Widget> buildRoomPageWidget()
{
  // List<Device> deviceList = [
  //   Light(value: 1, name: "Light", id: 1),
  //   AirConditioner(value: 0, name: "Air Conditioner", id: 2),
  //   Fan(value: 1, name: "Fan", id: 3),
  // ];

  // List<Widget> ret = [];
  // ret.add(RoomInfo(temperature: 30, humidity: 80, brightness: 1000));
  // for(Device d in deviceList)
  // {
  //   ret.add(DeviceTile(device: d));
  // }
  // return ret;
}