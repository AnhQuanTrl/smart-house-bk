import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:smarthouse/blocs/home_page_bloc.dart';
import 'package:smarthouse/presentations/components/room_expand_tile.dart';
import 'package:smarthouse/models/room.dart';
import 'package:smarthouse/presentations/home_page/heading_tile.dart';
import 'package:smarthouse/presentations/home_page/room_tile.dart';
import 'package:smarthouse/providers/device_provider.dart';
import 'package:smarthouse/providers/room_provider.dart';

import '../../blocs/home_page_bloc.dart';
import 'device_tile.dart';

//class HomePage extends StatefulWidget {
//  static const String routeName = "/";
//  @override
//  _HomePageState createState() => _HomePageState();
//}
//
//class _HomePageState extends State<HomePage> {
//  HomePageBloc bloc = HomePageBloc();
//
//  TextEditingController _nameController = TextEditingController();
//  @override
//  void initState() {
//    bloc.fetch();
//    super.initState();
//  }
//
//  Function onEdittingName(int id, String newName) => () {
//        bloc.updateRoom(id, newName);
//      };
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      floatingActionButton: FloatingActionButton(
//        child: Icon(Icons.add),
//        onPressed: () {
//          showModalBottomSheet(
//              context: context,
//              builder: (context) => Container(
//                    child: Column(
//                      children: <Widget>[
//                        Text('Add room'),
//                        TextField(controller: _nameController),
//                        FlatButton(
//                          child: Text('Submit'),
//                          onPressed: () {
//                            bloc.addRoom(_nameController.text);
//                            Navigator.of(context).pop();
//                          },
//                        )
//                      ],
//                    ),
//                  ));
//          bloc.addRoom(_nameController.text);
//        },
//      ),
//      appBar: AppBar(
//        title: Text('Rooms'),
//      ),
//      body: StreamBuilder(
//        stream: bloc.roomListStream,
//        builder: (context, snapshot) {
//          if (snapshot.hasData)
//            return Padding(
//              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
//              child: Column(
//                crossAxisAlignment: CrossAxisAlignment.start,
//                children: <Widget>[
//                  Text('Summary'),
//                  Row(
//                    children: <Widget>[
//                      Container(
//                          width: 150,
//                          height: 100,
//                          color: Colors.red,
//                          child: Column(
//                            crossAxisAlignment: CrossAxisAlignment.start,
//                            children: <Widget>[
//                              Text("Devices", style: TextStyle(color: Colors.white, fontSize: 20),),
//                              SizedBox(height: 40),
//                              Align(
//                                child: Text('50', style: TextStyle(color: Colors.white, fontSize: 20),),
//                                alignment: Alignment.bottomRight,
//                              )
//                            ],
//                          )),
//                      SizedBox(
//                        width: 30,
//                      ),
//                      Container(
//                          width: 150,
//                          height: 100,
//                          color: Colors.red,
//                          child: Column(
//                            crossAxisAlignment: CrossAxisAlignment.start,
//                            children: <Widget>[
//                              Text("Devices"),
//                              Align(
//                                child: Text('50'),
//                                alignment: Alignment.bottomRight,
//                              )
//                            ],
//                          )),
//                    ],
//                  ),
//                  Expanded(
//                    child: ListView.builder(
//                      itemBuilder: (context, i) {
//                        Key key = UniqueKey();
//                        return Dismissible(
//                          child: RoomExpandTile(
//                            onEdittingName: onEdittingName,
//                            room: snapshot.data[i],
//                          ),
//                          key: key,
//                          onDismissed: (_) {
//                            bloc.removeRoom(snapshot.data[i].id);
//                          },
//                        );
//                      },
//                      itemCount: snapshot.hasData ? snapshot.data.length : 0,
//                    ),
//                  ),
//                ],
//              ),
//            );
//          return Center(
//            child: CircularProgressIndicator(),
//          );
//        },
//      ),
//    );
//  }
//}

class HomePage extends StatefulWidget {
  static const String routeName = "/";
  @override
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Provider.of<DeviceProvider>(context, listen: false).fetch();
    Provider.of<RoomProvider>(context, listen: false).fetch();
  }
  @override
  Widget build(BuildContext context) {
    RoomProvider roomProvider =  Provider.of<RoomProvider>(context);
    DeviceProvider deviceProvider =  Provider.of<DeviceProvider>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text(
          "Smart house",
        ),
      ),
      body: ListView(children: <Widget>[
        HeadingTile("Rooms"),
        ...roomProvider.rooms.map((room) => RoomTile(room)).toList(),
        HeadingTile("Unassigned Devices"),
        ...deviceProvider.unassginedDevices.map((device) => DeviceTile(device.name)).toList()
      ],)
    );
  }
}