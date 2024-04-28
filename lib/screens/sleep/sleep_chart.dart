import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:health_companion_app/contollers/daily_sleep_controller.dart';
import 'package:intl/intl.dart';
import 'package:health_companion_app/models/chart_data.dart';
import 'package:health_companion_app/screens/sleep/daily_sleep_chart.dart';
import 'package:health_companion_app/screens/sleep/general_sleep_chart.dart';
import 'package:health_companion_app/models/db_models/daily_sleep.dart';
import 'package:health_companion_app/utils/time_utils.dart';

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
        timeInBedMinsHours = getTimeInBedHoursMins(dailySleepData.mins);
        chartData = [ChartData('', dailySleepData.mins.toDouble())];
      }
    });
  }
  
  Future<bool> getSleepData (String tab) async {
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
    return true;
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
          FutureBuilder(
            future: getSleepData(widget.tabName),
            builder: (BuildContext context,AsyncSnapshot<bool?> snapshot ){
              if(chartData != null){
                return Column(
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
                );
              }else if (snapshot.hasError){
                return Text('Error: ${snapshot.error}');
              }else{
                return Center(
                    child:
                    CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
    );
  }
}

