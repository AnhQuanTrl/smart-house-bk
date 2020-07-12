import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smarthouse/exception/authentication_exception.dart';
import 'package:smarthouse/models/devices/device.dart';
import 'package:smarthouse/presentations/pages/light_bulb_details_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../utils/api.dart' as api;

class LightBulb extends Device {
  final storage = FlutterSecureStorage();

  int value;
  Map<String, List<Map<String, int>>> statistic = {};
  void setValue(int newValue) {
    value = newValue;
    notifyListeners();
    changeValue(newValue);
  }

  LightBulb({this.value, @required String name, @required int id})
      : super(name: name, id: id);

  @override
  Widget buildLeading() {
    return Icon(Icons.lightbulb_outline);
  }

  @override
  Widget buildTitle() {
    return Text(name);
  }

  @override
  Widget buildTrailing() {
    return Wrap(
      spacing: 12,
      children: <Widget>[
        Icon(
          Icons.brightness_1,
          color: value > 0 ? Colors.orange : Colors.grey,
        ),
        Text(value.toString())
      ],
    );
  }

  @override
  void onTap(BuildContext context) {
    Navigator.pushNamed(context, LightBulbDetailsPage.routeName, arguments: id);
  }

  Future<void> changeValue(int newValue) async {
    final jwt = await storage.read(key: 'jwt');
    Map<String, Object> map = {"id": id, "value": newValue};
    String body = json.encode(map);
    try {
      var res = await http.post(api.server + "api/devices/control",
          body: body,
          headers: {
            "Content-Type": "application/json",
            "Authorization": jwt
          }).timeout(const Duration(seconds: 5));
      if (res.statusCode != 200) {
        throw AuthenticationException(json.decode(res.body).message);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<void> getStat() async {
    statistic = {};
    final jwt = await storage.read(key: 'jwt');
    try {
      var res = await http.get(api.server + "api/devices/stat/$id",
          headers: {"Authorization": jwt}).timeout(const Duration(seconds: 5));
      if (res.statusCode != 200) {
        throw AuthenticationException(json.decode(res.body).message);
      }
      Map<String, dynamic> mapper = json.decode(res.body);
      mapper.forEach((key, value) {
        statistic[key] = [];
        List<dynamic> lst = value;
        lst.forEach((element) {
          Map<String, int> el = {};
          element.forEach((key, value) {
            el[key] = value as int;
          });
          statistic[key].add(el);
        });
        statistic[key].sort((a, b) => a["time"].compareTo(b["time"]));
      });
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }
}
