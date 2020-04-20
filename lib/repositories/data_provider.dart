import 'dart:async';

import 'package:smarthouse/data.dart';
import 'package:smarthouse/models/room.dart';

class DataProvider {
  DataProvider._() {
    fetch();
  }

  static final DataProvider _instance = DataProvider._();
  factory DataProvider() {
    return _instance;
  }

  List<Room> data;
  StreamController<List<Room>> _dataStreamController = StreamController.broadcast();
  Stream get dataStream => _dataStreamController.stream;
  StreamSink get dataSink => _dataStreamController.sink;

  Room selectedRoom;
  StreamController<Room> _selectedRoomStreamController = StreamController.broadcast();
  
  Future<List<Room>> fetch() async {
    data = mockData;
    await Future.delayed(Duration(seconds: 3));
    return data;
  }
  
  void dispose( ) {
    _dataStreamController.close();
    _selectedRoomStreamController.close();
  }
}
