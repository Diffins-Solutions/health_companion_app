import 'package:flutter/material.dart';
import 'package:health_companion_app/models/weekly_sleep_plan.dart';
import 'package:health_companion_app/screens/onboarding/daily_move_goal.dart';
import 'package:health_companion_app/utils/constants.dart';
import 'package:health_companion_app/widgets/custom_flat_button.dart';
import 'package:health_companion_app/utils/os_utils.dart';

class SleepScheduleScreen extends StatefulWidget {
  static String id = 'sleep_schedule_screen';

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

  void updateWeeklyTimePlan(bool isWakeupTime, TimeOfDay? time) {
    isWakeupTime
        ? weeklySleepPlan.setWakeupTimeForTheDay(selectedDay, time)
        : weeklySleepPlan.setSleepTimeForTheDay(selectedDay, time);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          updateWeeklyTimePlan(false, selectedTime);
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
                          updateWeeklyTimePlan(true, selectedTime);
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
            Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                      child:
                          Container()), // Empty container to push text to the right
                  GestureDetector(
                    onTap: () => {},
                    child: Text(
                      'Skip  >>',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: OSUtils.isAndroid() ? 30 : 80,
            ),
            CustomFlatButton(
              label: 'Continue',
              color: kLightGreen,
              onPressed: () {
                for (var plan in weeklySleepPlan.weeklySleepPlan) {
                  print(plan.day);
                  print(plan.getWakeupTime());
                  print(plan.getSleepTime());
                }
                Navigator.pushNamed(context, DailyMoveGoal.id);
              },
              icon: Icons.navigate_next,
            ),
          ],
        ),
      ),
    );
  }
}
