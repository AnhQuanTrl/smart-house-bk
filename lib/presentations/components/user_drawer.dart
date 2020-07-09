import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:smarthouse/presentations/pages/auth_page.dart';
import 'package:smarthouse/providers/device_provider.dart';

class UserDrawer extends StatelessWidget {
  UserDrawer({this.showErrorDialog});
  final storage = FlutterSecureStorage();
  void showRegisterDialog(
      BuildContext context, TextEditingController controller) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        context: context,
        isScrollControlled: true,
        builder: (context) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: TextField(
                      decoration: InputDecoration(labelText: "DeviceId"),
                      controller: controller,
                    ),
                  ),
                  SizedBox(height: 20),
                  FlatButton(
                    child: Text('Register'),
                    onPressed: () {
                      Provider.of<DeviceProvider>(context, listen: false)
                          .registerDevice(controller.text)
                          .catchError((e) {
                        showErrorDialog(e.toString());
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ));
  }

  final Function showErrorDialog;

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(padding: EdgeInsets.zero, children: <Widget>[
        DrawerHeader(
          child: Text('User Interface'),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
        ),
        ListTile(
          leading: Icon(Icons.vpn_key),
          title: Text('Register Device'),
          onTap: () {
            Navigator.pop(context);
            showRegisterDialog(context, controller);
          },
        ),
        ListTile(
          leading: Icon(Icons.exit_to_app),
          title: Text('Logout'),
          onTap: () {
            storage.delete(key: "jwt");
            Navigator.of(context).pushNamed(AuthPage.routeName);
          },
        ),
      ]),
    );
  }
}
