import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smarthouse/models/devices/device.dart';
import 'package:smarthouse/models/devices/light_bulb.dart';
import 'package:smarthouse/models/devices/light_sensor.dart';
import '../utils/api.dart' as api;
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'dart:convert';

class WebSocketProvider with ChangeNotifier {
  final storage = FlutterSecureStorage();
  StompClient _stompClient;
  List<Device> newDevices = [];
  void setStompClient(String jwt, Function onDisconnect) {
    _stompClient = StompClient(
        config: StompConfig(
            url: '${api.wsServer}/ws',
            onConnect: onConnect,
            onWebSocketError: (dynamic error) => print(error.toString()),
            stompConnectHeaders: {'Authorization': jwt, 'name': jwt},
            webSocketConnectHeaders: {'Authorization': jwt},
            onDisconnect: onDisconnect));
  }

  dynamic onConnect(StompClient client, StompFrame frame) {
    client.subscribe(
        destination: '/user/topic/message',
        callback: (StompFrame frame) {
          var element = json.decode(frame.body);
          if (element['type'] == 'LB') {
            newDevices.add((new LightBulb(
                id: element['id'],
                name: element['name'],
                value: element['value'])));
          } else {
            newDevices.add(new LightSensor(
                id: element['id'],
                name: element['name'],
                value: element['light']));
          }

          notifyListeners();
        });
  }

  void open() {
    if (_stompClient != null) {
      _stompClient.activate();
    }
  }

  void close() {
    if (_stompClient != null) {
      _stompClient.deactivate();
    }
  }

  void dispose() {
    close();
    super.dispose();
  }
}
