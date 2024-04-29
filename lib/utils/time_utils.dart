import 'package:flutter/material.dart';

String getTimeOfDay(DayPeriod period) {
  return period.name == 'am' ? 'AM' : 'PM';
}

int getTimeInBedMins(TimeOfDay sleepTime, TimeOfDay wakeupTime) {
  Duration start = Duration(hours: sleepTime.hour, minutes: sleepTime.minute);
  Duration end = Duration(hours: wakeupTime.hour, minutes: wakeupTime.minute);

  if (sleepTime.hour == 0) {
    start = Duration(hours: 24, minutes: sleepTime.minute);
  }
  if (wakeupTime.hour == 0) {
    end = Duration(hours: 24, minutes: wakeupTime.minute);
  }
  if (sleepTime.hour > 12 && wakeupTime.hour < 12) {
    Duration midnight = Duration(hours: 24, minutes: 0);
    return (midnight - start + end).inMinutes.abs();
  }
  return (end - start).inMinutes.abs();
}

String getTimeInBedHoursMins(int? mins){
  if (mins == null) {
    return "0 hours";
  } else if (mins%60 == 0) {
    return "${mins ~/ 60}hours";
  }
  return "${mins ~/ 60}hours ${mins % 60}mins";
}

TimeOfDay convertTime(String? unformattedtime){
  if (unformattedtime != null) {
    List<String> timeParts = unformattedtime.split(":");
    int hours = int.parse(timeParts[0]);
    int mins = int.parse(timeParts[1]);
    return TimeOfDay(hour: hours, minute: mins);
  }
  return TimeOfDay(hour: 00, minute: 00);
}

String getTimeString(TimeOfDay time) {
  int hours = time.hour == 0 ? 12 : time.hour < 12 ? time.hour : time.hour - 12;
  String mins = time.minute < 10 ? "0${time.minute}" : time.minute.toString();

  return "$hours.${mins} ${getTimeOfDay(time.period)}";
}

int getWeekNumber(DateTime date) {
  final firstDayOfMonth = DateTime(date.year, date.month);
  final offset = (firstDayOfMonth.weekday - 1) % 7;
  final day = date.day;
  return ((day + offset) / 7).ceil();
}

List<DateTime> getNextSevenDays() {
  List<DateTime> nextDays = [];
  for (var i =0; i < 7 ; i ++) {
    DateTime nextDay = DateTime.now().add(Duration(days: i));
    nextDays.add(nextDay);
  }
  return nextDays;
}
