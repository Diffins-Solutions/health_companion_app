import 'package:flutter/material.dart';
import 'package:health_companion_app/models/daily_sleep_plan.dart';

class WeeklySleepPlan{
  List<DailySleepPlan> weeklySleepPlan = [
    DailySleepPlan(day: 'M'),
    DailySleepPlan(day: 'T'),
    DailySleepPlan(day: 'W'),
    DailySleepPlan(day: 'Th'),
    DailySleepPlan(day: 'F'),
    DailySleepPlan(day: 'St'),
    DailySleepPlan(day: 'S'),

  ];

  void setSleepTimeForTheDay(String day, TimeOfDay time){
    int index = weeklySleepPlan.indexWhere((plan) => plan.day == day);

    if (index != -1) {
      weeklySleepPlan[index].setSleepTime(time);
    } else {
      // Handle the case where no plan is found for 'MON'
      print("No $day sleep plan found");
    }
  }

  void setWakeupTimeForTheDay(String day, TimeOfDay time){
    int index = weeklySleepPlan.indexWhere((plan) => plan.day == day);

    if (index != -1) {
      weeklySleepPlan[index].setWakeupTime(time);
    } else {
      // Handle the case where no plan is found for 'MON'
      print("No $day sleep plan found");
    }
  }

  DailySleepPlan? getDailySleepPlan(String day){
    return weeklySleepPlan.firstWhere((plan) => plan.day == day);
  }

}
