// import 'package:flutter/material.dart';
// import 'package:smarthouse/models/devices/device.dart';

// class DeviceTile extends StatefulWidget {
//   final Device device;
//   DeviceTile({this.device});
//   @override
//   _DeviceTileState createState() => _DeviceTileState();
// }

// class _DeviceTileState extends State<DeviceTile> {
//   @override
//   Widget build(BuildContext context) {
//     String asset;
//     asset = widget.device.assetDir;

//     return Container(
//       padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
//       margin: EdgeInsets.all(5.0),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10.0),
//       ),
//       child: Column(
//         children: <Widget>[
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: <Widget>[
//               IconButton(
//                 icon: Image.asset(asset),
//                 onPressed: () {},
//               ),
//               Switch(
//                 value: widget.device.value == 0 ? false : true,
//                 activeTrackColor: Colors.blue[900],
//                 activeColor: Colors.grey[100],
//                 inactiveTrackColor: Colors.grey[400],
//                 onChanged: widget.device.switchValueOnChange,
//               )
//             ],
//           ),
//           Row(
//             children: <Widget>[
//               Text(
//                 widget.device.name,
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }