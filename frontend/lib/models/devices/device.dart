import 'package:flutter/material.dart';
import '../room.dart';

abstract class Device with ChangeNotifier {
  int id;
  String name;
  Room room;
  Device({this.id, this.name});
  Widget buildLeading();
  Widget buildTitle();
  Widget buildTrailing();
  void onTap(BuildContext context);
}
