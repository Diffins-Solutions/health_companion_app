import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:health_companion_app/screens/onboarding/sleep_schedule_screen.dart';
import 'package:health_companion_app/utils/constants.dart';
import 'package:health_companion_app/widgets/custom_flat_button.dart';
import '../../widgets/custom_input_field.dart';

class DailyMoveGoal extends StatefulWidget {
  static String id = 'daily_move_goal_screen';

  final Map<String, dynamic> previousData;
  final int? steps;

  DailyMoveGoal({required this.previousData, this.steps});

  @override
  State<DailyMoveGoal> createState() => _DailyMoveGoalsState();
}

class _DailyMoveGoalsState extends State<DailyMoveGoal> {
  int steps = 1000;
  bool _showInputDialog = false;

  @override
  void initState() {
    super.initState();
    if (widget.steps != null) {
      setState(() {
        steps = widget.steps!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
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
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 30),
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
                              steps--;
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
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _showInputDialog = true;
                                });
                              },
                              child: Text(
                                steps.toString(),
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                ),
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
                              steps++;
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
                  label: 'Continue',
                  color: kLightGreen,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SleepScheduleScreen(
                          previousData: {
                            'uid': widget.previousData['uid'],
                            'name': widget.previousData['name'],
                            'age': widget.previousData['age'],
                            'gender': widget.previousData['gender'],
                            'height': widget.previousData['height'],
                            'weight': widget.previousData['weight'],
                            'steps': steps,
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            _showInputDialog
                ? AlertBox(
                    previousData: widget.previousData,
              steps: widget.steps,
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}

class AlertBox extends StatefulWidget {
  final Map<String, dynamic> previousData;
  final int? steps;

  AlertBox({required this.previousData, required this.steps});

  @override
  State<AlertBox> createState() => _AlertBoxState();
}

class _AlertBoxState extends State<AlertBox> {
  int? _prevSteps;
  int? _newSteps;

  @override
  void initState(){
    super.initState();
    setState(() {
      _prevSteps = widget.steps;
      _newSteps = widget.steps;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Container(
          color: Colors.black.withOpacity(0.6),
        ),
        Container(
          padding: EdgeInsets.all(20),
          height: 150,
          width: 300,
          color: kActiveCardColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomInputField(
                  textInputType: TextInputType.number,
                  hint: 'Enter Your Daily Steps Goal..',
                  onChange: (value) => {_newSteps = int.parse(value)}),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DailyMoveGoal(
                                previousData: widget.previousData, steps: _prevSteps)),
                      );
                    },
                    child: Text(
                      "CANCEL",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: "Hind-Regular",
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DailyMoveGoal(
                                previousData: widget.previousData, steps: _newSteps)),
                      );
                    },
                    child: Text(
                      "OK",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: "Hind-Regular",
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}

