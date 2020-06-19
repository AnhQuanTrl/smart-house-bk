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
  void setValue(int newValue) {
    value = newValue;
    notifyListeners();
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
          color: value > 0 ? Colors.deepOrangeAccent : Colors.grey,
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
        print(res.statusCode);
        throw AuthenticationException(json.decode(res.body).message);
      }
      await Future.delayed(Duration(milliseconds: 100));
      setValue(newValue);
    } catch (e) {
      throw e;
    }
  }
}
