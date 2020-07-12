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
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(5.0))),
                  isScrollControlled: true,
                  context: context,
                  builder: (context) => Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          SizedBox(height: 20),
                          TextField(
                            style: TextStyle(fontSize: 20),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: EdgeInsets.all(15),
                              hintText: "Enter Room Name",
                              hintStyle: TextStyle(fontSize: 20),
                            ),
                            autofocus: true,
                            onChanged: (name) => roomName = name,
                          ),
                          SizedBox(height: 20),
                          Align(
                            alignment: Alignment.centerRight,
                            child: FlatButton(
                                child: Text('Add room',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.cyan)),
                                onPressed: () {
                                  Room newRoom = Room(roomName, []);
                                  if (roomName != null)
                                    context
                                        .read<RoomProvider>()
                                        .addRoom(newRoom);
                                  Navigator.of(context).pop();
                                }),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
          : null,
    );
  }
}
