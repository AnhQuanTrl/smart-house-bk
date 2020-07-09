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

  int getNumberOfHoursUsed(LightBulb value, int day) {
    List<Map<String, int>> data = value.statistic[day.toString()];
    if (data == null) {
      return 0;
    }
    data.sort((a, b) => a["time"].compareTo(b["time"]));
    int zeroIndex;
    int start = 0;
    Duration duration = Duration();
    for (zeroIndex = data.indexWhere((element) => element["value"] == 0, start);
        zeroIndex != -1;
        zeroIndex =
            data.indexWhere((element) => element["value"] == 0, start)) {
      print(DateTime.fromMillisecondsSinceEpoch(data[zeroIndex]["time"]));
      print(DateTime.fromMillisecondsSinceEpoch(data[start]["time"]));
      duration += DateTime.fromMillisecondsSinceEpoch(data[zeroIndex]["time"])
          .difference(DateTime.fromMillisecondsSinceEpoch(data[start]["time"]));
      start = zeroIndex + 1;
    }
    return duration.inHours;
  }

  Map<String, int> getWeekHourUsed(LightBulb lightBulb, int minus) {
    Map<String, int> mapper = {};
    for (DateTime date = DateTime.now().subtract(Duration(days: minus * 7 - 1));
        date.compareTo(DateTime.now().subtract(Duration(
              days: (minus - 1) * 7,
            ))) <
            0;
        date = date.add(Duration(days: 1))) {
      mapper[DateFormat('EEE').format(date)] =
          getNumberOfHoursUsed(lightBulb, date.day);
    }
    return mapper;
  }
}
