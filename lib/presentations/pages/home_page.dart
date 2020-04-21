import "package:flutter/material.dart";
import 'package:smarthouse/blocs/home_page_bloc.dart';
import 'package:smarthouse/presentations/components/room_expand_tile.dart';

class HomePage extends StatefulWidget {
  static const String routeName = "/";
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomePageBloc bloc = HomePageBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rooms'),
      ),
      body: StreamBuilder(
        stream: bloc.data,
        builder: (context, snapshot) {
          return ListView.builder(
            itemBuilder: (context, i) => RoomExpandTile(room: snapshot.data[i]),
            itemCount: snapshot.hasData ? snapshot.data.length : 0,
          );
        },
      ),
    );
  }
}
