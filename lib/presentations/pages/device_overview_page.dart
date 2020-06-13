import "package:flutter/material.dart";
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:smarthouse/exception/authentication_exception.dart';
import 'package:smarthouse/presentations/components/device_overview_list.dart';
import 'package:smarthouse/providers/device_provider.dart';
import 'package:smarthouse/providers/room_provider.dart';
import 'package:smarthouse/providers/web_socket_provider.dart';

import 'auth_page.dart';

class DeviceOverviewPage extends StatefulWidget {
  static const String routeName = "/devices";
  @override
  _DeviceOverviewPageState createState() => _DeviceOverviewPageState();
}

class _DeviceOverviewPageState extends State<DeviceOverviewPage> {
  bool _isLoading;
  bool _isInit = true;
  final storage = FlutterSecureStorage();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      return;
    }
    _refresh();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> _attempRefresh() async {
    try {
      var jwt = await storage.read(key: 'jwt');
      Provider.of<WebSocketProvider>(context, listen: false)
        ..close()
        ..setStompClient(jwt)
        ..open();
      await (Provider.of<DeviceProvider>(context, listen: false)..setJwt(jwt))
          .fetch();
      await ((Provider.of<RoomProvider>(context, listen: false)..setJwt(jwt))
          .fetch());
    } on AuthenticationException {
      Navigator.of(context).pushReplacementNamed(AuthPage.routeName);
    } catch (e) {
      print(e);
      _showErrorDialog("Something Wrong");
    } finally {
      setState(() {
        _isLoading = false;
        _isInit = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: Text(
            "Smart house",
          ),
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : DeviceOverviewList(
                refresh: _refresh,
              ));
  }

  Future<void> _refresh() {
    {
      setState(() {
        _isLoading = true;
      });
      return _attempRefresh();
    }
  }
}
