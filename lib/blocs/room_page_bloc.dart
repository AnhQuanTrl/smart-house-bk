

import 'package:smarthouse/models/room.dart';
import 'package:smarthouse/repositories/data_provider.dart';

import 'base.dart';

class RoomPageBloc extends Bloc {
  DataProvider _provider = DataProvider();
  final int roomId;
  Room room;
  RoomPageBloc({this.roomId}) {
    room = _provider.findRoomById(roomId);
  }

  void fetch() async {

  }

  @override
  void dispose() {

  }

}