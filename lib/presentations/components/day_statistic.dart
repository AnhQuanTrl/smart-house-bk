import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smarthouse/models/devices/light_bulb.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';

import 'chart/custom_time_series_chart.dart';

class DayStatistic extends StatefulWidget {
  @override
  _DayStatisticState createState() => _DayStatisticState();
}

class _DayStatisticState extends State<DayStatistic> {
  DateTime date = DateTime.now();
  @override
  Widget build(BuildContext context) {
    LightBulb lb = Provider.of<LightBulb>(context, listen: false);
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Text(
            "Daily Usage",
            style: Theme.of(context).textTheme.headline4,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: getNumberOfHoursUsed(lb, context, date.day),
        ),
        RaisedButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(Icons.date_range),
                    Text('${DateFormat.yMMMd().format(date)}'),
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
                Text('Choose Day'),
              ],
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            elevation: 4.0,
            onPressed: () async {
              DateTime chosenDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now().subtract(Duration(days: 30)),
                  lastDate: DateTime.now());
              setState(() {
                date = chosenDate;
              });
            }),
        Container(
          height: 250,
          margin: EdgeInsets.all(10),
          child: CustomTimeSeriesChart(
            animate: true,
            data: lb.statistic[date.day.toString()],
          ),
        ),
      ],
    );
  }

  Widget getNumberOfHoursUsed(LightBulb value, BuildContext context, int day) {
    List<Map<String, int>> data = value.statistic[day.toString()];
    data.sort((a, b) => a["time"].compareTo(b["time"]));
    int zeroIndex;
    int start = 0;
    Duration duration = Duration();
    for (zeroIndex = data.indexWhere((element) => element["value"] == 0, start);
        zeroIndex != -1;
        zeroIndex =
            data.indexWhere((element) => element["value"] == 0, start)) {
      print(zeroIndex);
      duration += DateTime.fromMillisecondsSinceEpoch(data[zeroIndex]["time"])
          .difference(DateTime.fromMillisecondsSinceEpoch(data[start]["time"]));
      print(duration);
      start = zeroIndex + 1;
    }
    return Text(
      "${duration.inHours} hours",
      style: Theme.of(context).textTheme.headline4,
    );
  }
}
