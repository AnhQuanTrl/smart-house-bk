import 'dart:async';

import 'package:demo_painter/services/data_provider.dart';
import 'package:flutter/material.dart';
import 'base.dart';

class AppBloc extends Bloc {
  DataProvider _dataProvider;

  AppBloc() {
    _dataProvider = DataProvider();
    sink.add(_dataProvider.farmerList);
  }

  StreamController _streamController = StreamController();
  Stream get stream => _streamController.stream;
  StreamSink get sink => _streamController.sink;
  
  void add({@required String name, String address})  async {
    await Future.delayed(Duration(seconds: 3));
    _dataProvider.add(name: name, address: address);
    sink.add(_dataProvider.farmerList);
  }
  
  @override
  void dispose() {
    _streamController.close();
  }
}