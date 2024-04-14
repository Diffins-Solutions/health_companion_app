import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:health_companion_app/screens/landing/add_calories_popup.dart';
import 'package:health_companion_app/utils/constants.dart';
import 'package:health_companion_app/utils/enums.dart';
import 'package:arc_progress_bar_new/arc_progress_bar_new.dart';
import 'package:health_companion_app/widgets/welcome_text.dart';
import 'package:intl/intl.dart';

class LandingScreen extends StatefulWidget {
  static String id = 'landing_screen';

  final String name = 'Nethmi';
  final Gender gender = Gender.female;
  String formattedDate = DateFormat.yMMMMd().format(DateTime.now());
  final int targetSteps = 1000;
  final int coveredSteps = 200;
  double stpePercentage = 20.0;
  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          WelcomeText(name: widget.name, today: widget.formattedDate),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconContent(
                    iconData: FontAwesomeIcons.heartPulse,
                    value: '80 bpm',
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
                    value: '905 kcal',
                    label: 'Calories',
                    color: Colors.orangeAccent,
                    onTap: () => addCaloriesPopup(context),
                  ),
                  IconContent(
                      iconData: Icons.water_drop_rounded,
                      value: '2 liters',
                      label: 'Water',
                      color: Colors.blue),
                ],
              ),
              SizedBox(
                width: 50,
              ),
              Expanded(
                child: Image.asset(
                    'images/running${widget.gender == Gender.male ? 'm' : 'w'}.png'),
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
                percentage: widget.stpePercentage,
                bottomLeftWidget: Text(
                  "Begin",
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                bottomRightWidget: Text(
                  '${widget.coveredSteps} / ${widget.targetSteps}',
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
