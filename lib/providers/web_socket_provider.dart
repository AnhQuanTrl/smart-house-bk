import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smarthouse/models/devices/device.dart';
import '../utils/api.dart' as api;
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class WebSocketProvider with ChangeNotifier {
  final storage = FlutterSecureStorage();
  StompClient _stompClient;
  List<Device> newDevices = [];
  void setStompClient(String jwt) {
    _stompClient = StompClient(
        config: StompConfig(
            url: '${api.wsServer}/ws',
            onConnect: onConnect,
            onWebSocketError: (dynamic error) => print(error.toString()),
            stompConnectHeaders: {'Authorization': jwt},
            webSocketConnectHeaders: {'Authorization': jwt}));
  }

  dynamic onConnect(StompClient client, StompFrame frame) {
    client.subscribe(
        destination: '/topic/message',
        callback: (StompFrame frame) {
          print(frame.body);
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
