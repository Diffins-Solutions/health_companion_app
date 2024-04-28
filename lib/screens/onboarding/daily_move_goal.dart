import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:health_companion_app/utils/constants.dart';
import 'package:health_companion_app/widgets/custom_flat_button.dart';
import 'package:health_companion_app/screens/app_shell.dart';
import 'package:health_companion_app/contollers/user_controller.dart';
import 'package:health_companion_app/models/db_models/user.dart';
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

  void addUserData() async {
    print('adding user data');
    User user = User(
        name: widget.previousData['name'],
        age: widget.previousData['age'],
        height: widget.previousData['height'],
        weight: widget.previousData['weight'],
        gender: widget.previousData['gender'],
        steps: steps);
    bool response = await UserController.addUser(user);
    if (response == true) {
      Navigator.pushNamed(context, AppShell.id);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error Recording user data')));
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.steps != null) {
      setState(() {
        steps = widget.steps!;
      });
    }
    print(steps);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [Column(
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
                label: 'Finish Setup',
                color: kLightGreen,
                onPressed: () {
                  addUserData();
                },
              ),
            ],
          ),
            _showInputDialog
                ? AlertBox(
              previousData: widget.previousData,
            )
                : Container()
          ],
        ),
      ),
    );
  }
}

class AlertBox extends StatelessWidget {
  final Map<String, dynamic> previousData;

  AlertBox({required this.previousData});

  @override
  Widget build(BuildContext context) {
    int? _steps;

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
                  onChange: (value) => {_steps = int.parse(value)}),
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
                                previousData: previousData, steps: _steps)),
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
                                previousData: previousData, steps: _steps)),
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
