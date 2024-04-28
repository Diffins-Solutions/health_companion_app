import 'package:flutter/material.dart';
import 'package:health_companion_app/utils/constants.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:health_companion_app/models/chart_data.dart';

class GeneralSleepChart extends StatelessWidget {
  GeneralSleepChart(
      {super.key, this.chartData, required this.tabName});

  final List<ChartData>? chartData;
  final String tabName;

  final Map<String, int> maxSleepTimeLimits = {
    'W': 24 * 60 * 7,
    'M': 24 * 60 * 30,
    'Y': 24 * 60 * 365
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15.0),
      child: SfCartesianChart(
          primaryXAxis: CategoryAxis(),
          primaryYAxis: NumericAxis(
              minimum: 0,
              maximum: maxSleepTimeLimits[tabName]?.toDouble(),
              interval: 400000),
          series: <CartesianSeries<ChartData, String>>[
            BarSeries<ChartData, String>(
                dataSource: chartData,
                xValueMapper: (ChartData data, _) => data.x,
                yValueMapper: (ChartData data, _) => data.y1,
                name: 'Gold',
                color: kLightGreen)
          ]),
    );
  }
}