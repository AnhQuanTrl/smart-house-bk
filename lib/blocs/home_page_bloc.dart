import 'dart:async';
import 'package:smarthouse/repositories/data_provider.dart';
import 'base.dart';

class HomePageBloc extends Bloc {
  DataProvider _dataProvider;
  Stream data;
  StreamSink dataSink;
  HomePageBloc() {
    _dataProvider = DataProvider();
    data = _dataProvider.dataStream;
    dataSink = _dataProvider.dataSink;
  }

  @override
  void dispose() {
    dataSink.close();
  }
}
