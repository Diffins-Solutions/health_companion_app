import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_companion_app/utils/constants.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:health_companion_app/models/chart_data.dart';

class SleepChart extends StatelessWidget {
  String tabName;
  List<ChartData> chartData;

  SleepChart({required this.tabName, required this.chartData});

  bool isDaily() => tabName == "D";

  Map<String, String> titles = {
    'D': 'Today',
    'W': 'Past Week',
    'M': 'Past Month',
    'Y': 'Past Year'
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Time in bed",
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
              Text(
                //TODO: calculate the total time and assign it here
                "7hr31min",
                style: TextStyle(
                    fontSize: 30,
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Column(
            children: [
              Text(
                titles[tabName]!,
                style: TextStyle(
                    fontSize: 17,
                    color: Color(0xF017736a),
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 30,
              ),
              isDaily()
                  ? DailySleepChart(chartData: chartData)
                  : GeneralSleepChart(
                      chartData: chartData,
                      tabName: tabName,
                    ),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class GeneralSleepChart extends StatelessWidget {
  GeneralSleepChart(
      {super.key, required this.chartData, required this.tabName});

  final List<ChartData> chartData;
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

class DailySleepChart extends StatelessWidget {
  const DailySleepChart({
    super.key,
    required this.chartData,
  });

  final List<ChartData> chartData;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SimpleCircularProgressBar(
        valueNotifier: ValueNotifier(chartData[0].y1),
        mergeMode: true,
        size: 200,
        progressColors: [kLightGreen],
        backColor: kInactiveCardColor,
        progressStrokeWidth: 25,
        onGetText: (double value) {
          return Text(
            '${value.toInt()} mins',
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        },
      ),
    );
  }
}
