import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smarthouse/models/devices/light_bulb.dart';
import 'package:smarthouse/presentations/components/chart/custom_bar_chart.dart';

class WeekStatistic extends StatefulWidget {
  @override
  _WeekStatisticState createState() => _WeekStatisticState();
}

class _WeekStatisticState extends State<WeekStatistic> {
  int _minus = 1;
  @override
  Widget build(BuildContext context) {
    LightBulb lb = Provider.of<LightBulb>(context, listen: false);
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Text(
            "Weekly Usage",
            style: Theme.of(context).textTheme.headline4,
          ),
        ),
        ButtonBar(
          alignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            createWeekButton("Last", 1),
            createWeekButton("Second last", 2),
            createWeekButton("Third last", 3),
            createWeekButton("Fourth last", 4),
          ],
        ),
        Container(
          height: 250,
          margin: EdgeInsets.all(10),
          child: CustomBarChart(
            animate: true,
            data: getWeekHourUsed(lb, _minus),
          ),
        ),
      ],
    );
  }

  RaisedButton createWeekButton(String label, int minus) {
    return RaisedButton(
      child: Text(label),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      elevation: 4.0,
      onPressed: () {
        setState(() {
          _minus = minus;
        });
      },
    );
  }

  int getNumberOfHoursUsed(LightBulb value, int day, bool firstFlg) {
    List<Map<String, int>> data = value.statistic[day.toString()];
    if (data == null) {
      return 0;
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
    return duration.inMinutes % 60 >= 45
        ? duration.inHours + 1
        : duration.inHours;
  }

  Map<String, int> getWeekHourUsed(LightBulb lightBulb, int minus) {
    Map<String, int> mapper = {};
    for (DateTime date = DateTime.now().subtract(Duration(days: minus * 7 - 1));
        date.compareTo(DateTime.now().subtract(Duration(
              days: (minus - 1) * 7,
            ))) <
            0;
        date = date.add(Duration(days: 1))) {
      Map<String, int> lastMap =
          lightBulb.statistic[date.subtract(Duration(days: 1)).day]?.last;
      mapper[DateFormat('EEE').format(date)] = getNumberOfHoursUsed(lightBulb,
          date.day, (lastMap != null && lastMap['value'] != 0) ? true : false);
    }
    return mapper;
  }
}
