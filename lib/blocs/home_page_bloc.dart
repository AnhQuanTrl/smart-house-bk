import 'dart:async';
import 'package:smarthouse/repositories/data_provider.dart';
import 'base.dart';

class HomePageBloc extends Bloc {
  DataProvider _dataProvider;

  StreamController _roomListStreamController = StreamController();
  Stream get roomListStream => _roomListStreamController.stream;

  HomePageBloc() {
    _dataProvider = DataProvider();
  }

  void fetch() async {
    _dataProvider.fetch().then((value) => _roomListStreamController.add(value));
  }

  void addRoom(String text) async {
    _dataProvider.addRoom(text).then((value) {
      _roomListStreamController.add(_dataProvider.roomList);
    });
  }

  void removeRoom(id) async {
    _dataProvider.removeRoom(id).then((success) {
      _roomListStreamController.add(_dataProvider.roomList);
    });
  }

  @override
  void dispose() {
    _roomListStreamController.close();
  }

  void updateRoom(int id, String newName) async {
    _dataProvider.updateRoom(id, newName).then((success) {
      if (success) _roomListStreamController.add(_dataProvider.roomList);
    });
  }
}
