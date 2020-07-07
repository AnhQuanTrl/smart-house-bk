import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarthouse/models/devices/light_bulb.dart';
import 'package:smarthouse/presentations/components/chart/time_series_chart.dart';

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
    LightBulb lb = Provider.of<LightBulb>(context, listen: false);
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
                Column(
                  children: <Widget>[
                    Container(
                      height: 250,
                      margin: EdgeInsets.all(10),
                      child: TimeSeriesChart(
                        animate: true,
                        data: lb.statistic[day.toString()],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        "Daily Usage",
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Consumer<LightBulb>(
                        builder: (BuildContext context, LightBulb value,
                            Widget child) {
                          List<Map<String, int>> data =
                              value.statistic[DateTime.now().day];
                          data.sort((a, b) => a["time"].compareTo(b["time"]));
                          return Text(
                            "Daily Usage",
                            style: Theme.of(context).textTheme.headline4,
                          );
                        },
                      ),
                    ),
                  ],
                ),
                Text("dad"),
              ],
            ),
          )
        ],
      ),
    );
  }
}
