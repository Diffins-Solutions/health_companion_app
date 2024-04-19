import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:health_companion_app/contollers/daily_target_controller.dart';
import 'package:health_companion_app/contollers/food_calorie_controller.dart';
import 'package:health_companion_app/contollers/user_controller.dart';
import 'package:health_companion_app/models/db_models/daily_target.dart';
import 'package:health_companion_app/screens/landing/add_calories_popup.dart';
import 'package:health_companion_app/screens/landing/add_water_popup.dart';
import 'package:health_companion_app/utils/constants.dart';
import 'package:health_companion_app/utils/enums.dart';
import 'package:arc_progress_bar_new/arc_progress_bar_new.dart';
import 'package:health_companion_app/widgets/welcome_text.dart';
import 'package:intl/intl.dart';

import '../../models/db_models/food_calorie.dart';
import '../../models/db_models/user.dart';
import '../../models/step_counter.dart';

class LandingScreen extends StatefulWidget {
  static String id = 'landing_screen';
  String formattedDate = DateFormat.yMMMMd().format(DateTime.now());

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  double stepPercentage = 0.0;
  String name = 'Default user';
  Gender gender = Gender.female;
  int targetSteps = 0;
  int heart = 0;
  List<String> food = [];
  List<FoodCalorie> foodCalories = [];
  DailyTarget? dailyTargets;
  final _stepCounter = StepCounter();
  int _currentStepCount = 0;

  void getUser() async {
    User user = await UserController.getUser();
    if (user != null) {
      setState(() {
        name = user.name;
        gender = user.gender == 'Gender.female' ? Gender.female : Gender.male;
        targetSteps = user.steps;
        stepPercentage = (_currentStepCount / targetSteps) * 100;
        if (user.heart != null) {
          heart = user.heart!;
        }
      });
    }
  }

  void getFoodCalories() async {
    List<FoodCalorie> result = await FoodCalorieController.getFoodCalories();
    if (result.isNotEmpty) {
      print(result.length);
      setState(() {
        foodCalories = result;
        food = List.generate(result.length, (i) => result[i].food);
      });
    }
  }

  void getDailyTargets() async {
    DailyTarget? result = await DailyTargetController.getDailyTarget();
    setState(() {
      dailyTargets = result;
    });
  }

  @override
  void initState() {
    super.initState();
    getUser();
    getFoodCalories();
    getDailyTargets();
    // _stepCounter.startListening();
    // _stepCounter.stepCountStream.listen((stepCount) {
    //   setState(() {
    //     _currentStepCount = stepCount;
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          WelcomeText(name: name, today: widget.formattedDate),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconContent(
                    iconData: FontAwesomeIcons.heartPulse,
                    value: heart == 0 ? 'Not configured' : heart.toString(),
                    label: 'Heart',
                    color: Colors.red,
                  ),
                  IconContent(
                      iconData: FontAwesomeIcons.solidMoon,
                      value: '8 hrs',
                      label: 'Sleep',
                      color: Colors.yellow),
                  IconContent(
                    iconData: Icons.fastfood_rounded,
                    value: '${dailyTargets?.calorie == null ? 0: dailyTargets!.calorie} kcal',
                    label: 'Calories',
                    color: Colors.orangeAccent,
                    onTap: () => {
                      addCaloriesPopup(context, food, foodCalories, dailyTargets)
                          .then((e) => {getDailyTargets()})
                    },
                  ),
                  IconContent(
                      iconData: Icons.water_drop_rounded,
                      value: '${dailyTargets?.water == null ? 0: dailyTargets!.water} liters',
                      label: 'Water',
                      color: Colors.blue,
                    onTap: () => {
                        addWaterPopup(context, dailyTargets).then((e) => {getDailyTargets()})
                    },
                  ),
                ],
              ),
              SizedBox(
                width: 50,
              ),
              Expanded(
                child: Image.asset(
                    'images/running${gender == Gender.male ? 'm' : 'w'}.png'),
              ),
              SizedBox(
                width: 15,
              ),
            ],
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 40, left: 10, right: 10, bottom: 10),
            child: ArcProgressBar(
                percentage: stepPercentage,
                bottomLeftWidget: Text(
                  "Begin",
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                bottomRightWidget: Text(
                  '$_currentStepCount / $targetSteps',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                bottomCenterWidget: Text(
                  "STEPS",
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
                ),
                centerWidget: Icon(
                  FontAwesomeIcons.walking,
                  size: 50,
                ),
                arcThickness: 25,
                innerPadding: 15,
                animateFromLastPercent: true,
                handleSize: 0,
                backgroundColor: Colors.white30,
                foregroundColor: kLightGreen),
          ),
        ],
      ),
    );
  }
}

class IconContent extends StatelessWidget {
  final IconData iconData;
  final String label;
  final String value;
  final Color color;
  final Function()? onTap;

  IconContent(
      {required this.iconData,
      required this.value,
      required this.label,
      required this.color,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          SizedBox(
            width: 15,
          ),
          Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white30,
            ),
            child: Icon(
              iconData,
              color: color,
            ),
          ),
          SizedBox(
            width: 15.0,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
              Text(value)
            ],
          )
        ],
      ),
    );
  }
}
