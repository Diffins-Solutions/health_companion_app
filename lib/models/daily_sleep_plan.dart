import 'package:flutter/material.dart';

class DailySleepPlan{
  final String day;
  TimeOfDay _wakeupTime = TimeOfDay(hour: 0, minute: 0);
  TimeOfDay _sleepTime = TimeOfDay(hour: 0, minute: 0);

  DailySleepPlan({required this.day});

  TimeOfDay? getSleepTime (){
    return _sleepTime;
  }

  TimeOfDay? getWakeupTime (){
    return _wakeupTime;
  }

  void setSleepTime (TimeOfDay time){
    _sleepTime = time;
  }

  void setWakeupTime (TimeOfDay time){
    _wakeupTime = time;
  }

}