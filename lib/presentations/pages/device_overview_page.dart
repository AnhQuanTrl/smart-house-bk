import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:smarthouse/presentations/components/device_overview_list.dart';
import 'package:smarthouse/providers/device_provider.dart';
import 'package:smarthouse/providers/room_provider.dart';

class DeviceOverviewPage extends StatefulWidget {
  static const String routeName = "/devices";
  @override
  _DeviceOverviewPageState createState() => _DeviceOverviewPageState();
}

class _DeviceOverviewPageState extends State<DeviceOverviewPage> {
  bool _isLoading;
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      return;
    }
    _refresh();
  }

  Future<void> _attempRefresh() async {
    try {
      await Provider.of<DeviceProvider>(context, listen: false).fetch();
      await (Provider.of<RoomProvider>(context, listen: false).fetch());
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text(e.toString()),
        ),
      );
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
