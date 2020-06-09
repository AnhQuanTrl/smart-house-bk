// import 'dart:async';

// import 'package:smarthouse/models/room.dart';
// import 'package:smarthouse/services/roomService.dart' as rService;

// class DataProvider {
//   DataProvider._() {
//     fetch();
//   }

//   static DataProvider _instance;
//   factory DataProvider() {
//     if (_instance == null) {
//       _instance = DataProvider._();
//     }
//     return _instance;
//   }

//   List<Room> roomList;


//   Room selectedRoom;

//   Future<List<Room>> fetch() async {
//     roomList = await rService.fetchRoomRequest();

//     return roomList;
//   }

//   Room findRoomById(int id) {
//     for (Room r in roomList) {
//       if (r.id == id) {
//         return r;
//       }
//     }
//   }

//   Future addRoom(String name) async {
//     Room newRoom = await rService.addRoomRequest(name);
//     if (newRoom != null) roomList.add(newRoom);
//   }

//   Future<bool> removeRoom(id) async  {
//     return rService.removeRoomRequest(id);
//   }

//   Future updateRoom(int id, String newName) async {
//     bool success = await rService.updateRoomRequest(id, newName);
//     if (success) {
//       Room room = findRoomById(id);
//       room.name = newName;
//     }

//     return success;
//   }
// }
