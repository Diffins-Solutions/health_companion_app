import 'package:flutter/material.dart';
import 'package:health_companion_app/screens/onboarding/sleep_schedule_screen.dart';
import 'package:health_companion_app/utils/constants.dart';
import 'package:ruler_picker_bn/ruler_picker_bn.dart';
import 'package:health_companion_app/utils/os_utils.dart';
import '../../widgets/custom_flat_button.dart';

class WeightScreen extends StatefulWidget {
  static String id = 'weight_screen';
  final Map<String, dynamic> previousData;

  WeightScreen({required this.previousData});

  @override
  State<WeightScreen> createState() => _WeightScreenState();
}

class _WeightScreenState extends State<WeightScreen> {
  int weight = 60;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
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
                  width: OSUtils.isAndroid() ? 10 : 30,
                ),
                Text(
                  'How much do you weigh ?',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 50.0),
              child: Text(
                'These data can later be used to calculate your BMI and recommend more personalized health tips',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: kNormalSize,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 130,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    weight.toString(),
                    style: kNumberStyle,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'kg',
                    style: TextStyle(color: Colors.grey),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 40,
              child: RulerPicker(
                onChange: (val) {
                  setState(() {
                    weight = val;
                  });
                },
                background: kBackgroundColor,
                lineColor: kLightGreen,
                direction: Axis.horizontal,
                startValue: 60,
                minValue: 30,
                maxValue: 150,
                padding: EdgeInsets.all(10),
              ),
            ),
            CustomFlatButton(
              label: 'Continue',
              color: kLightGreen,
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SleepScheduleScreen(
                      previousData: {
                        'name': widget.previousData['name'],
                        'age': widget.previousData['age'],
                        'gender': widget.previousData['gender'],
                        'height': widget.previousData['height'],
                        'weight': weight,
                      },
                    ),
                  ),
                );
              },
              icon: Icons.navigate_next,
            ),
          ],
        ),
      ),
    );
  }
}
