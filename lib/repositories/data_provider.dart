import 'dart:async';

// import 'package:smarthouse/data.dart';
import 'package:smarthouse/data.dart';
import 'package:smarthouse/models/devices/device.dart';
import 'package:smarthouse/models/room.dart';

class DataProvider {
  DataProvider._() {
    fetch();
  }

  static DataProvider _instance;
  factory DataProvider() {
    if (_instance == null) {
      _instance = DataProvider._();
    }
    return _instance;
  }

  List<Room> data;
  StreamController _dataStreamController = StreamController.broadcast();
  Stream get dataStream => _dataStreamController.stream;
  StreamSink get dataSink => _dataStreamController.sink;

  Room selectedRoom;
  StreamController<Room> _selectedRoomStreamController =
      StreamController<Room>.broadcast();

  Future<List<Room>> fetch() async {
    data = mockData;

    await Future.delayed(Duration(seconds: 3));
    _dataStreamController.add(data);
    return data;
  }

  Room findRoomById(int id) {
    for (Room r in data) {
      if (r.id == id) {
        return r;
      }
    }
  }

  void dispose() {
    _dataStreamController.close();
    _selectedRoomStreamController.close();
  }
}
