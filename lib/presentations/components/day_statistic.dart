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
    Map<String, int> lastMap =
        lb.statistic[date.subtract(Duration(days: 1)).day]?.last;
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
          padding: EdgeInsets.only(bottom: 20),
          child: getNumberOfHoursUsed(lb, context, date.day,
              (lastMap != null && lastMap['value'] != 0) ? true : false),
        ),
        RaisedButton(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.date_range),
                      Text('${DateFormat.yMMMd().format(date)}'),
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                ),
                SizedBox(
                  width: 40,
                ),
                Text('Choose Day'),
              ],
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            onPressed: () async {
              DateTime chosenDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now().subtract(Duration(days: 30)),
                  lastDate: DateTime.now());
              if (chosenDate == null) {
                return;
              }
              setState(() {
                date = chosenDate;
              });
            }),
        Container(
          height: 250,
          margin: EdgeInsets.all(10),
          child: CustomTimeSeriesChart(
            animate: true,
            currentDate: date,
            data: lb.statistic[date.day.toString()],
            firstValue: lastMap != null ? lastMap.values.elementAt(0) : 0,
          ),
        ),
      ],
    );
  }

  Widget getNumberOfHoursUsed(
      LightBulb value, BuildContext context, int day, bool firstFlg) {
    List<Map<String, int>> data = value.statistic[day.toString()];
    if (data == null) {
      return Text("0 Hours");
    }
    data.sort((a, b) => a["time"].compareTo(b["time"]));
    int zeroIndex;
    int start = 0;
    Duration duration = Duration();
    if (firstFlg == true) {
      DateTime currentDateTime =
          DateTime.fromMillisecondsSinceEpoch(data[0]["time"]);
      duration += currentDateTime.difference(DateTime(currentDateTime.year,
          currentDateTime.month, currentDateTime.day, 0, 0, 1));
    }

    for (zeroIndex = data.indexWhere((element) => element["value"] == 0, start);
        zeroIndex != -1;
        zeroIndex =
            data.indexWhere((element) => element["value"] == 0, start)) {
      duration += DateTime.fromMillisecondsSinceEpoch(data[zeroIndex]["time"])
          .difference(DateTime.fromMillisecondsSinceEpoch(data[start]["time"]));
      start = zeroIndex + 1;
    }
    int lastZeroIndex = data.lastIndexWhere((element) => element["value"] == 0);
    if (lastZeroIndex < data.length - 1) {
      DateTime lastTime =
          DateTime.fromMillisecondsSinceEpoch(data[lastZeroIndex + 1]["time"]);

      DateTime last = day == DateTime.now().day
          ? DateTime.now()
          : DateTime(lastTime.year, lastTime.month, lastTime.day, 23, 59, 59);
      duration += last.difference(lastTime);
    }
    return Text(
      "${duration.inMinutes % 60 >= 45 ? duration.inHours + 1 : duration.inHours} hours",
      style: Theme.of(context).textTheme.headline4,
    );
  }
}
