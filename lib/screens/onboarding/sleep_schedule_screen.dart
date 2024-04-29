import 'dart:math';

import 'package:flutter/material.dart';
import 'package:health_companion_app/contollers/sleep_target_controller.dart';
import 'package:health_companion_app/contollers/user_controller.dart';
import 'package:health_companion_app/models/daily_sleep_plan.dart';
import 'package:health_companion_app/models/local_notifications.dart';
import 'package:health_companion_app/models/db_models/sleep_target.dart';
import 'package:health_companion_app/models/db_models/user.dart';
import 'package:health_companion_app/models/weekly_sleep_plan.dart';
import 'package:health_companion_app/screens/app_shell.dart';
import 'package:health_companion_app/utils/constants.dart';
import 'package:health_companion_app/utils/time_utils.dart';
import 'package:health_companion_app/widgets/custom_flat_button.dart';
import 'package:health_companion_app/utils/os_utils.dart';

class SleepScheduleScreen extends StatefulWidget {
  static String id = 'sleep_schedule_screen';
  final Map<String, dynamic> previousData;

  SleepScheduleScreen({required this.previousData});

  @override
  State<SleepScheduleScreen> createState() => _SleepScheduleScreenState();
}

class _SleepScheduleScreenState extends State<SleepScheduleScreen> {
  WeeklySleepPlan weeklySleepPlan = WeeklySleepPlan();
  String selectedDay = 'M';
  TimeOfDay? wakeupTime = TimeOfDay(hour: 00, minute: 00);
  TimeOfDay? bedTime = TimeOfDay(hour: 00, minute: 00);

  String getTimeOfDay(int hours) {
    return OSUtils.isIOS()
        ? hours - 12 < 0
            ? 'AM'
            : 'PM'
        : '';
  }

  String getSelectedTimeString(TimeOfDay? selectedTime) {
    if (selectedTime != null) {
      String timeOfDay = getTimeOfDay(selectedTime.hour);
      return '${selectedTime.format(context)} ${timeOfDay}';
    } else {
      return '00:00 AM'; // Handle case where user cancels the picker
    }
  }

  void addUserData() async {
    print(
        'adding user data uid = ${widget.previousData['uid']} steps = ${widget.previousData['steps']}');

    User user = User(
        name: widget.previousData['name'],
        uid: widget.previousData['uid'],
        age: widget.previousData['age'],
        height: widget.previousData['height'],
        weight: widget.previousData['weight'],
        gender: widget.previousData['gender'],
        steps: widget.previousData['steps']);
    bool response = await UserController.addUser(user);
    if (response == true) {
      User user =
          await UserController.getCurrentUser(widget.previousData['uid']);
      if (user != null) {
        await addSleepSchedule(user.id!);
      }
      Navigator.pushNamedAndRemoveUntil(
          context, AppShell.id, (Route<dynamic> route) => false);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error Recording user data')));
    }
  }

  void updateWeeklyTimePlan(bool isWakeupTime, TimeOfDay? time) {
    isWakeupTime
        ? weeklySleepPlan.setWakeupTimeForTheDay(selectedDay, time!)
        : weeklySleepPlan.setSleepTimeForTheDay(selectedDay, time!);
  }

  String formatTimeForDB(TimeOfDay? time) {
    return "${time?.hour}:${time?.minute}";
  }

  Future<void> addSleepSchedule(int userId) async {
    List<SleepTarget> sleep_targets = [];
    List<DateTime> nextWeek = getNextSevenDays();
    Random random = Random();
    List<DailySleepPlan> plan = weeklySleepPlan.weeklySleepPlan;
    for (var i = 0; i < plan.length; i++) {
      int randomNumber = random.nextInt(1000) + 1;

      TimeOfDay? sleepTime = plan[i].getSleepTime();
      TimeOfDay? wakeupTime = plan[i].getWakeupTime();

      DateTime sleep = DateTime(nextWeek[i].year, nextWeek[i].month,
          nextWeek[i].day, sleepTime!.hour, sleepTime.minute);
      DateTime wakeup = DateTime(nextWeek[i].year, nextWeek[i].month,
          nextWeek[i].day, wakeupTime!.hour, wakeupTime.minute);

      await LocalNotifications.showWeeklyNotification(
          id: randomNumber, dateTime: sleep);
      await LocalNotifications.showWeeklyAlarm(
          id: randomNumber+1, dateTime: wakeup);
      sleep_targets.add(SleepTarget(
          userId: userId,
          day: plan[i].day,
          sleep: formatTimeForDB(plan[i].getSleepTime()),
          wakeup: formatTimeForDB(plan[i].getWakeupTime())));
    }
    print('adding sleep schedule');
    await SleepTargetController.addSleepTargets(sleep_targets);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                GestureDetector(
                  child: Icon(
                    Icons.navigate_before,
                    size: 40,
                  ),
                  onTap: () => Navigator.pop(context),
                ),
                SizedBox(
                  width: 100,
                ),
                Text(
                  'Sleep Plan',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            SizedBox(
              height: 40,
            ),
            Image.asset('images/moon_1.png'),
            SizedBox(
              height: 60,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      'Bed Time',
                      style:
                          TextStyle(fontSize: kNormalSize, color: Colors.grey),
                    ),
                    GestureDetector(
                      onTap: () async {
                        TimeOfDay? selectedTime = await showTimePicker(
                          initialTime: TimeOfDay.now(),
                          context: context,
                          builder: (context, child) {
                            return Theme(
                              data: ThemeData.light()
                                  .copyWith(colorScheme: kTimePickerTheme),
                              child: child!,
                            );
                          },
                        );
                        setState(() {
                          bedTime = selectedTime;
                          updateWeeklyTimePlan(false, selectedTime!);
                        });
                      },
                      child: Text(
                        getSelectedTimeString(bedTime),
                        style: TextStyle(
                            fontSize: 20, decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 60,
                ),
                Column(
                  children: [
                    Text(
                      'Wakeup Time',
                      style:
                          TextStyle(fontSize: kNormalSize, color: Colors.grey),
                    ),
                    GestureDetector(
                      onTap: () async {
                        TimeOfDay? selectedTime = await showTimePicker(
                          initialTime: TimeOfDay.now(),
                          context: context,
                          builder: (context, child) {
                            return Theme(
                              data: ThemeData.light()
                                  .copyWith(colorScheme: kTimePickerTheme),
                              child: child!,
                            );
                          },
                        );
                        setState(() {
                          wakeupTime = selectedTime;
                          updateWeeklyTimePlan(true, selectedTime!);
                        });
                      },
                      child: Text(
                        getSelectedTimeString(wakeupTime),
                        style: TextStyle(
                            fontSize: 20, decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 60,
            ),
            Text(
              'Sleep Schedule',
              style: TextStyle(color: Colors.grey),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 0),
              child: Row(
                children: weeklySleepPlan.weeklySleepPlan
                    .map((dailyPlan) => Expanded(
                          child: MaterialButton(
                            onPressed: () {
                              setState(() {
                                selectedDay = dailyPlan.day;
                                bedTime = dailyPlan.getSleepTime();
                                wakeupTime = dailyPlan.getWakeupTime();
                              });
                            },
                            child: Text(dailyPlan.day),
                            color: selectedDay == dailyPlan.day
                                ? kLightGreen
                                : kDarkGreen,
                            padding: EdgeInsets.all(10),
                            shape: CircleBorder(),
                          ),
                        ))
                    .toList(),
              ),
            ),
            SizedBox(
              height: OSUtils.isAndroid() ? 20 : 80,
            ),
            CustomFlatButton(
              label: 'Finish Setup',
              color: kLightGreen,
              onPressed: () {
                addUserData();
              },
              icon: Icons.navigate_next,
            ),
          ],
        ),
      ),
    );
  }
}
