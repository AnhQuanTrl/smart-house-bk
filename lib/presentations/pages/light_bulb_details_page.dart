import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarthouse/models/devices/light_bulb.dart';
import 'package:smarthouse/presentations/components/chart/custom_time_series_chart.dart';
import 'package:smarthouse/presentations/components/light_bulb_information.dart';
import 'package:smarthouse/presentations/components/light_bulb_statistic.dart';
import 'package:smarthouse/providers/device_provider.dart';

class LightBulbDetailsPage extends StatefulWidget {
  static const String routeName = "/light-bulb";
  final int id;

  const LightBulbDetailsPage({this.id});

  @override
  _LightBulbDetailsPageState createState() => _LightBulbDetailsPageState();
}

class _LightBulbDetailsPageState extends State<LightBulbDetailsPage> {
  int _selectedIndex = 0;
  bool _isLoading = true;
  bool _showTab = false;

  LightBulb lb;
  @override
  void initState() {
    lb = Provider.of<DeviceProvider>(context, listen: false).findById(widget.id)
        as LightBulb;
    lb.getStat().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  static List<Widget> _widgetOptions = <Widget>[
    LightBulbInformation(),
    LightBulbStatistic(),
  ];
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: lb,
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: Text(
            "Light Bulb",
          ),
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _widgetOptions[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.perm_device_information),
                title: Text('Information')),
            BottomNavigationBarItem(
                icon: Icon(Icons.show_chart), title: Text('Statistic')),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Theme.of(context).accentColor,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
