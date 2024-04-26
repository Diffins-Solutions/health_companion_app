import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_companion_app/contollers/daily_sleep_controller.dart';
import 'package:health_companion_app/utils/constants.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:health_companion_app/models/chart_data.dart';

import 'package:health_companion_app/models/db_models/daily_sleep.dart';


class SleepChart extends StatefulWidget {
  final String tabName;
  final int? timeInBed;

  const SleepChart({super.key, required this.tabName, this.timeInBed});

  @override
  State<SleepChart> createState() => _SleepChartState();
}

class _SleepChartState extends State<SleepChart>
    with SingleTickerProviderStateMixin {
  bool isDaily() => widget.tabName == "D";
  List<ChartData>? chartData;
  Map<String, String> titles = {
    'D': 'Today',
    'W': 'Past Week',
    'M': 'Past Month',
    'Y': 'Past Year'
  };
  Map<String, int>? timeInBedMinsHours = {'hours' : 0, 'mins': 0};

  Map<String, int> getTimeInBedHoursMins(int? mins){
    mins = mins ?? 0;
    return {"hours":mins ~/ 60, "mins": mins % 60};
  }

  void formatYearlyChartData (List<DailySleep> yearlySleepData) {
    Map<String, int> yearlyData = {};
    int totalmins = 0;
    for(DailySleep data in yearlySleepData) {
      DateTime date = DateTime.parse(data.day);
      String month = DateFormat('MMMM').format(date).substring(0, 3);
      print(data.day);
      print(data.mins);
      if (yearlyData.keys.contains(month)) {
        yearlyData[month] =  yearlyData[month]! + data.mins;
      } else {
        yearlyData[month] = data.mins;
      }
      totalmins += data.mins;
    }
    setState(() {
      timeInBedMinsHours = getTimeInBedHoursMins(totalmins);
      List<String> months = yearlyData.keys.toList();
      chartData = months.map((month) => ChartData(month, yearlyData[month]!.toDouble())).toList();
    });
  }

  int getWeekNumber(DateTime date) {
    final firstDayOfMonth = DateTime(date.year, date.month);
    final offset = (firstDayOfMonth.weekday - 1) % 7;
    final day = date.day;
    return ((day + offset) / 7).ceil();
  }

  void formatMonthlyChartData (List<DailySleep> monthlySleepData) {
    Map<String, int> monthlyData = {};
    int totalMins = 0;
    for(DailySleep data in monthlySleepData) {
      DateTime date = DateTime.parse(data.day);
      int weekNumber = getWeekNumber(date);
      String mapKey = "Week $weekNumber";
      if (monthlyData.keys.contains(mapKey)) {
        monthlyData[mapKey] =  monthlyData[mapKey]! + data.mins;
      } else {
        monthlyData[mapKey] = data.mins;
      }
      totalMins += data.mins;
    }
    setState(() {
      timeInBedMinsHours = getTimeInBedHoursMins(totalMins);
      List<String> weeks = monthlyData.keys.toList();
      chartData = weeks.map((week) => ChartData(week, monthlyData[week]!.toDouble())).toList();
    });
  }

  void formatWeeklyChartData (List<DailySleep> monthlySleepData) {
    Map<String, int> weeklyData = {};
    int totalMins = 0;
    for(DailySleep data in monthlySleepData) {
      DateTime date = DateTime.parse(data.day);
      int weekNumber = getWeekNumber(date);
      int currentWeekNumber = getWeekNumber(DateTime.now());
      if (weekNumber != currentWeekNumber) {
        continue;
      } else {
        totalMins += data.mins;
        weeklyData[DateFormat('EEE').format(date)] = data.mins;
      }
    }
    setState(() {
      timeInBedMinsHours = getTimeInBedHoursMins(totalMins);
      List<String> weekDays = weeklyData.keys.toList();
      chartData = weekDays.map((day) => ChartData(day, weeklyData[day]!.toDouble())).toList();
    });
  }

  void formatDailyChartData (DailySleep? dailySleepData) {
    setState(() {
      timeInBedMinsHours = getTimeInBedHoursMins(widget.timeInBed);
      chartData = [ChartData('', widget.timeInBed!.toDouble())];
      if (dailySleepData != null) {
        print('not null');
        timeInBedMinsHours = getTimeInBedHoursMins(dailySleepData.mins);
        chartData = [ChartData('', dailySleepData.mins.toDouble())];
      }
    });
  }
  
  void getSleepData (String tab) async {
    DateTime time = DateTime.now();
    switch(tab) {
      case'Y':
        List<DailySleep> data =  await DailySleepController.getYearlySleepData(time.year.toString());
        formatYearlyChartData(data);
        break;
      case 'M':
        List<DailySleep> data = await DailySleepController.getMonthlySleepData(time.year.toString(), time.month.toString());
        formatMonthlyChartData(data);
        break;
      case 'W':
        List<DailySleep> data = await DailySleepController.getMonthlySleepData(time.year.toString(), time.month.toString());
        formatWeeklyChartData(data);
        break;
      case 'D':
        DailySleep? data = await DailySleepController.getDailySleepData();
        formatDailyChartData(data);
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    getSleepData(widget.tabName);
  }
  
  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Time in bed",
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
              Text(
                "${timeInBedMinsHours?["hours"]}hr ${timeInBedMinsHours?["mins"]}min",
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
                titles[widget.tabName]!,
                style: TextStyle(
                    fontSize: 17,
                    color: Color(0xF017736a),
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 30,
              ),
              isDaily()
                  ? DailySleepChart(chartData: chartData!)
                  : GeneralSleepChart(
                      chartData: chartData,
                      tabName: widget.tabName,
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

class DailySleepChart extends StatelessWidget {
  const DailySleepChart({
    super.key,
    required this.chartData,
  });

  final List<ChartData> chartData;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SimpleCircularProgressBar(
            valueNotifier: ValueNotifier(chartData[0].y1),
            mergeMode: true,
            size: 200,
            progressColors: [kLightGreen],
            backColor: kInactiveCardColor,
            progressStrokeWidth: 25,
            maxValue: 24*60,
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
          SizedBox(
            height: 40,
          ),
          Text(
            "Achieve optimal wellness by tracking your sleep patterns daily"
                " and striving for a consistent, quality rest every night.",
            style: const TextStyle(
              fontSize: 15,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
