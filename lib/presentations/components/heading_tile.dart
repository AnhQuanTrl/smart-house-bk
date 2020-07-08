import 'package:flutter/material.dart';
import 'package:smarthouse/models/room.dart';
import 'package:smarthouse/providers/room_provider.dart';
import 'package:provider/provider.dart';

class HeadingTile extends StatelessWidget {
  final String heading;
  const HeadingTile(this.heading);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        heading,
        style: Theme.of(context).textTheme.headline5,
      ),
      trailing: heading == "Rooms"
          ? IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                String roomName;
                showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (context) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                child: TextField(
                                  decoration:
                                      InputDecoration(labelText: "Room Name"),
                                  autofocus: true,
                                  onChanged: (name) => roomName = name,
                                ),
                              ),
                              SizedBox(height: 20),
                              FlatButton(
                                  child: Text('Add room'),
                                  onPressed: () {
                                    Room newRoom = Room(roomName, []);
                                    if (roomName != null)
                                      context
                                          .read<RoomProvider>()
                                          .addRoom(newRoom);
                                    Navigator.of(context).pop();
                                  }),
                            ],
                          ),
                        ));
              },
            )
          : null,
    );
  }
}
