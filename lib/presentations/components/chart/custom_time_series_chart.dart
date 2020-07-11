import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import "package:collection/collection.dart";

class CustomTimeSeriesChart extends StatelessWidget {
  final List<Map<String, int>> data;
  final bool animate;
  final int firstValue;
  final DateTime currentDate;
  List<charts.Series<dynamic, DateTime>> seriesList;
  CustomTimeSeriesChart(
      {this.data, this.animate, this.firstValue, this.currentDate}) {
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
      defaultRenderer: new charts.BarRendererConfig<DateTime>(),
      defaultInteractions: false,
      behaviors: [new charts.SelectNearest(), new charts.DomainHighlighter()],
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

  int getAverageValueByHour(List<Map<String, Object>> data, int firstValue) {
    if (data == null) {
      return firstValue;
    }
    DateTime current = data[0]["time"] as DateTime;
    int currentSum = (current.minute * 60 + current.second) * firstValue;
    for (int i = 1; i < data.length; i++) {
      DateTime next = data[i]["time"] as DateTime;
      currentSum +=
          next.difference(current).inSeconds * (data[i - 1]["value"] as int);
      current = next;
    }
    currentSum += ((60 - current.minute - 1) * 60 + (60 - current.second)) *
        (data.last["value"] as int);
    return currentSum ~/ 3600;
  }

  List<charts.Series<TimeSeriesValue, DateTime>> constructSeriesList(
      List<Map<String, int>> data) {
    if (data == null) {
      data = [];
    }
    List<Map<String, Object>> newData = data
        .map((mapper) => {
              "time": DateTime.fromMillisecondsSinceEpoch(mapper["time"]),
              "value": mapper["value"]
            })
        .toList();
    newData = [
      {
        "time": DateTime(
            currentDate.year, currentDate.month, currentDate.day, 0, 0, 0),
        "value": firstValue
      },
      ...newData
    ];
    final Map<int, List<Map<String, Object>>> groupByHour = groupBy(
        newData, (Map<String, Object> obj) => ((obj["time"]) as DateTime).hour);
    List<Map<String, Object>> mapList = [];
    int maxHour = DateTime.now().difference(currentDate).inHours < 24
        ? DateTime.now().hour
        : 24;
    print(maxHour);
    for (int key = 0; key < maxHour; key++) {
      int first = firstValue;
      if (key != 0) {
        for (int i = key; i > 0; i--) {
          if (groupByHour[i] != null) {
            first = groupByHour[i].last["value"];
            break;
          }
        }
      }
      List<Map<String, Object>> value = groupByHour[key] ?? null;
      mapList.add({
        "time": DateTime(
            currentDate.year, currentDate.month, currentDate.day, key, 0, 0),
        "value": getAverageValueByHour(
          value,
          first,
        )
      });
    }

    final List<TimeSeriesValue> lst = mapList
        .map(
          (mapper) => TimeSeriesValue(
            mapper["time"],
            mapper["value"],
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
