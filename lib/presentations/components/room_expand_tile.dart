import "package:flutter/material.dart";
import 'package:smarthouse/models/devices/device.dart';

import 'package:smarthouse/models/room.dart';
import 'package:smarthouse/presentations/room_page/room_page.dart';

import 'device_tile.dart';

class RoomExpandTile extends StatelessWidget {
  final _nameController = TextEditingController();
  final Room room;
  final Function onEdittingName;
  RoomExpandTile({Key key, this.room, this.onEdittingName}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: GestureDetector(
          child: Row(children: [
            IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) => Container(
                            child: Column(
                              children: <Widget>[
                                Text('Change name'),
                                TextField(controller: _nameController),
                                FlatButton(
                                  child: Text('Submit'),
                                  onPressed: () {
                                    onEdittingName(
                                        room.id, _nameController.text)();
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            ),
                          ));
                }),
            Text(room.name)
          ]),
          onTap: () {
            // Navigator.of(context)
            //     .pushNamed(RoomPage.routeName, arguments: room.id);
          }),
      children: buildDeviceListTile(),
      initiallyExpanded: true,
    );
  }

  List<Widget> buildDeviceListTile() {
    List<Widget> devicesTiles = [];
    for (Device d in room.deviceList) {
      devicesTiles.add(DeviceTile(device: d));
    }
    return devicesTiles;
  }
}
