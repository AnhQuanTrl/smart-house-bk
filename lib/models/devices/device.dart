import 'package:flutter/material.dart';
import '../room.dart';
abstract class Device{
  int id;
  String name;
  Room room;
  Device({this.id, this.name});
  Widget buildLeading();
  Widget buildTitle();
  Widget buildTrailing();
  void onTap(BuildContext context);
}

