import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarthouse/models/devices/light_bulb.dart';
import 'package:smarthouse/presentations/components/chart/custom_time_series_chart.dart';
import 'package:smarthouse/presentations/components/week_statistic.dart';

import 'day_statistic.dart';

class LightBulbStatistic extends StatefulWidget {
  @override
  _LightBulbStatisticState createState() => _LightBulbStatisticState();
}

class _LightBulbStatisticState extends State<LightBulbStatistic>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  final List<Widget> tabs = [
    Container(
      child: Tab(
        child: Text("D"),
      ),
    ),
    Tab(
      child: Text("W"),
    ),
  ];

  @override
  void initState() {
    _tabController = new TabController(length: tabs.length, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int day = DateTime.now().day;
    return Container(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Container(
              child: TabBar(
                tabs: tabs,
                controller: _tabController,
                indicator: BoxDecoration(color: Colors.cyan),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
              ),
              color: Colors.white),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                DayStatistic(),
                WeekStatistic(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
