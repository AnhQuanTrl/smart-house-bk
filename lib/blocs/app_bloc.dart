import 'dart:async';
import 'package:smarthouse/repositories/data_provider.dart';
import 'base.dart';

class AppBloc extends Bloc {
  DataProvider _dataProvider;

  AppBloc() {
    _dataProvider = DataProvider();
    sink.add(_dataProvider.data);
  }

  StreamController _dataStreamController = StreamController();
  Stream get stream => _dataStreamController.stream;
  StreamSink get sink => _dataStreamController.sink;
  
  @override
  void dispose() {
    _dataStreamController.close();
  }
}