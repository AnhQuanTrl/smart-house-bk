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
    print(MediaQuery.of(context).viewInsets.bottom);
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(5.0))),
        context: context,
        isScrollControlled: true,
        builder: (context) => Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: SingleChildScrollView(
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
                        hintText: "Enter Device Id",
                        hintStyle: TextStyle(fontSize: 20),
                      ),
                      controller: controller,
                    ),
                    SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerRight,
                      child: FlatButton(
                        child: Text(
                          'Register',
                          style: TextStyle(fontSize: 20, color: Colors.cyan),
                        ),
                        onPressed: () {
                          Provider.of<DeviceProvider>(context, listen: false)
                              .registerDevice(controller.text)
                              .catchError((e) {
                            showErrorDialog(e.toString());
                          });
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
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
