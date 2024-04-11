import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:health_companion_app/utils/constants.dart';
import 'package:health_companion_app/widgets/custom_flat_button.dart';
import 'package:health_companion_app/screens/app_shell.dart';

class DailyMoveGoal extends StatefulWidget {
  static String id = 'daily_move_goal_screen';

  @override
  State<DailyMoveGoal> createState() => _DailyMoveGoalsState();
}

class _DailyMoveGoalsState extends State<DailyMoveGoal> {

  int noOfCalories = 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
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
                      width: 20,
                    ),
                    Text(
                      'Your Daily Move Goal ?',
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
                  child: Text(
                    'Formulate a goal that aligns with your current level of activity or the level of activity you aim to accomplish each day.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                SizedBox(
                  height: 150,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        setState(() {
                          noOfCalories--;
                        });
                      },
                      shape: CircleBorder(),
                      color: kLightGreen,
                      child: Text(
                        '-',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          noOfCalories.toString(),
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Steps/ Day',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                    MaterialButton(
                      onPressed: () {
                        setState(() {
                          noOfCalories++;
                        });
                      },
                      shape: CircleBorder(),
                      color: kLightGreen,
                      child: Text(
                        '+',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            CustomFlatButton(
              label: 'Finish Setup',
              color: kLightGreen,
              onPressed: () {
                Navigator.pushNamed(context, AppShell.id);
              },
              icon: Icons.navigate_next,
            ),
          ],
        ),
      ),
    );
  }
}
