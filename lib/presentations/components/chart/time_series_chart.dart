import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import "package:collection/collection.dart";
import 'dart:math';

class TimeSeriesChart extends StatelessWidget {
  final List<Map<String, int>> data;
  final bool animate;

  List<charts.Series<dynamic, DateTime>> seriesList;
  TimeSeriesChart({this.data, this.animate}) {
    seriesList = constructSeriesList(data);
  }

  // factory TimeSeriesChart.withSampleData() {
  //   return TimeSeriesChart(
  //     _createSampleData(),
  //     animate: false,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return new charts.TimeSeriesChart(
      seriesList,
      animate: animate,
      domainAxis: charts.DateTimeAxisSpec(
        tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
          hour: charts.TimeFormatterSpec(
              format: 'HH:mm', transitionFormat: 'HH:mm'),
          minute: charts.TimeFormatterSpec(
              format: 'HH:mm', transitionFormat: 'HH:mm'),
        ),
      ),
    );
  }

  // Create one series with sample hard coded data.
  // static List<charts.Series<TimeSeriesSales, DateTime>> _createSampleData() {
  //   final data = [
  //     new TimeSeriesSales(new DateTime(2017, 9, 19), 5),
  //     new TimeSeriesSales(new DateTime(2017, 9, 26), 25),
  //     new TimeSeriesSales(new DateTime(2017, 10, 3), 100),
  //     new TimeSeriesSales(new DateTime(2017, 10, 10), 75),
  //   ];

  //   return [
  //     new charts.Series<TimeSeriesSales, DateTime>(
  //       id: 'Sales',
  //       colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
  //       domainFn: (TimeSeriesSales sales, _) => sales.time,
  //       measureFn: (TimeSeriesSales sales, _) => sales.sales,
  //       data: data,
  //     )
  //   ];
  // }

  List<charts.Series<TimeSeriesValue, DateTime>> constructSeriesList(
      List<Map<String, int>> data) {
    final Map<int, List<Map<String, Object>>> groupByHour = groupBy(
        (data..sort((a, b) => a["time"].compareTo(b["time"]))).map((mapper) => {
              "time": DateTime.fromMillisecondsSinceEpoch(mapper["time"]),
              "value": mapper["value"]
            }),
        (Map<String, Object> obj) => ((obj["time"]) as DateTime).minute);
    List<Map<String, Object>> mapList = [];
    groupByHour.forEach((key, value) {
      mapList.add({
        "time": value[0]["time"],
        "value": value.fold(0,
                (previousValue, element) => previousValue + element["value"]) /
            value.length
      });
    });
    final List<TimeSeriesValue> lst = mapList
        .map(
          (mapper) => TimeSeriesValue(
            mapper["time"],
            (mapper["value"] as double).toInt(),
          ),
        )
        .toList();
    return [
      charts.Series<TimeSeriesValue, DateTime>(
        id: 'Values',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (val, _) => val.time,
        measureFn: (TimeSeriesValue val, _) => val.value,
        data: lst,
      )
    ];
  }
}

class TimeSeriesValue {
  final DateTime time;
  final int value;

  TimeSeriesValue(this.time, this.value);
}
