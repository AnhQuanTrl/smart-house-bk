import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class CustomBarChart extends StatelessWidget {
  final Map<String, int> data;
  final bool animate;

  CustomBarChart({this.animate, this.data});

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      _createSeriesList(data),
      animate: animate,
    );
  }

  static List<charts.Series<WeekHour, String>> _createSeriesList(
      Map<String, int> data) {
    List<WeekHour> lst = [];
    data.forEach((key, value) {
      lst.add(WeekHour(key, value));
    });
    return [
      new charts.Series<WeekHour, String>(
        id: 'Hour Total',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (wh, _) => wh.week,
        measureFn: (wh, _) => wh.hour,
        data: lst,
      )
    ];
  }
}

class WeekHour {
  final String week;
  final int hour;

  WeekHour(this.week, this.hour);
}
