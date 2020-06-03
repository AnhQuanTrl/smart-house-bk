import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:smarthouse/models/room.dart';
import 'package:http/http.dart' as http;

class RoomProvider with ChangeNotifier {
  List<Room> rooms;
  
  void addRoom(Room room) {

  }

  void fetch() async {
    rooms = new List<Room>();
    var res = await http.get("http://10.0.128.151:8080/api/rooms/");
    List<dynamic> roomList = json.decode(res.body);
    roomList.forEach((element) {
      rooms.add(new Room(element['name'], null, id: element['id']));
    });
    notifyListeners();
  }
}