// import 'dart:convert';

// import "package:http/http.dart" as http;
// import 'package:smarthouse/models/room.dart';
// import 'package:smarthouse/utils/api.dart';

// fetchRoomRequest() async {
//   //return json list room id
//   // [
//   //     {name, deviceIdlist},
//   //     {name, deviceIdlist},
//   //   ]
//   var res = await http.get(request('/rooms'));
//   List<Room> listRoom = [];
//   print(json.decode(res.body));
//   if (res.statusCode == 404) return [];
//   for (Map room in json.decode(res.body)) {
//     print(room);
//     listRoom.add(Room.fromMap(room));
//   }
//   return listRoom;
// }

// fetchDeviceRequest() async {
//   //  [
//   //     {id, roomid, type, ...},
//   //     {id, roomid, type, ...},
//   //     {id, roomid, type, ...},
//   //   ]
//   // }
//   return await http.get(request('/fetch-devices'));
// }

// Future<Room> addRoomRequest(String name) async {
//   // req = {
//   //   name: "abc"
//   // }
//   // res = {
//   //   success: true,
//   //   id: 3,
//   // }
//   http.Response res = await http.post(
//     request('/create-room'),
//     body: json.encode({"name": name}),
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//     },
//   );
//   var result = json.decode(res.body);
//   var success = res.statusCode == 200;
//   print(result);
//   int id = result['id'];
//   if (success == true) {
//     Room newRoom = Room(name, [], id: id);
//     return newRoom;
//   } else
//     return null;
// }

// Future<bool> removeRoomRequest(int id) async {
//   // res = {
//   //   success: 1,
//   //   id: 3,
//   // }

//   var res = await http.get(request("/remove-room/$id"));
//   var result = json.decode(res.body);
//   var success = result['success'];
//   success = true;
//   return success;
// }

// Future<bool> updateRoomRequest(int id, String newName) async {
//   // res = {
//   //   success: true
//   // }
//   // request {id: 1, name: "ashjjdjkahsd"}
//   var res = await http.put(
//     request("/update-room/$id"),
//     body: json.encode({
//       "name": newName,
//     }),
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//     },
//   );
//   print(res.statusCode);
//   return res.statusCode == 200;
// }

// fetchRoomById(int id) {
//   // room : {
//   //   success:
//   // }
// }
