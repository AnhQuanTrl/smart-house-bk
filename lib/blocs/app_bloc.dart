import 'dart:async';
import 'package:smarthouse/repositories/data_provider.dart';
import 'base.dart';

class AppBloc extends Bloc {
  DataProvider _dataProvider;

  StreamController _dataStreamController = StreamController();
  Stream get dataStream => _dataStreamController.stream;
  StreamSink get dataSink => _dataStreamController.sink;

  AppBloc() {
    _dataProvider = DataProvider();
    dataSink.add(_dataProvider.roomList);
  }

  @override
  void dispose() {
    _dataStreamController.close();
  }

  // void createRoom() async ()
}