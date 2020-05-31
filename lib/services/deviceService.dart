import "package:http/http.dart" as http;
import 'package:smarthouse/models/devices/device.dart';
import 'package:smarthouse/utils/api.dart';

Future<Device> fetchDeviceById(int id) async {
  //return json list room id
  // {
  //   roomList: [
  //     {id, name, deviceIdlist},
  //     {id, name, deviceIdlist},
  //   ]
  //   unregisterDeviceId : []
  // };
  http.Response res = await http.get(request('/device/$id'));
}

fetchRoom(int id) async {
  //return json list room id
  // {
  //   roomList: [
  //     {id, name, deviceIdlist},
  //     {id, name, deviceIdlist},
  //   ]
  //   unregisterDeviceId : []
  // };

  return await http.get(request('/room/$id'));
}

Future<String> addRoom(String name) async {
  http.Response res = await http.post(request('/createRoom'), body: name);
  return res.body;
}

Future<String> removeRoom(int id) async {
  var res = await http.get(request("/removeRoom/:$id"));
  return res.body;
}

Future<String> update(int id) async {
  var res = await http.post(request("/room/$id/update"));
  return res.body;
}
