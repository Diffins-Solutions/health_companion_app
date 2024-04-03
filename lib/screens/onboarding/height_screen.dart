import 'package:flutter/material.dart';
import 'package:health_companion_app/utils/constants.dart';
import 'package:ruler_picker_bn/ruler_picker_bn.dart';
import 'package:health_companion_app/screens/onboarding/weight_screen.dart';

import '../../widgets/custom_flat_button.dart';

class HeightScreen extends StatefulWidget {
  static String id = 'height_screen';

  @override
  State<HeightScreen> createState() => _HeightScreenState();
}

class _HeightScreenState extends State<HeightScreen> {
  int height = 120;

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
                  width: 40,
                ),
                Text(
                  'How tall are you ?',
                  style: TextStyle(
                      fontSize: kHeadingSize, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 50.0),
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
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    width: 80,
                    height: 500,
                    child: RulerPicker(
                      onChange: (val) {
                        setState(() {
                          height = val;
                        });
                      },
                      background: kBackgroundColor,
                      lineColor: kLightGreen,
                      direction: Axis.vertical,
                      startValue: 120,
                      minValue: 90,
                      maxValue: 210,
                      padding: EdgeInsets.all(10),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.only(top: 8.0, bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          height.toString(),
                          style: kNumberStyle,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'cm',
                          style: TextStyle(color: Colors.grey),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            CustomFlatButton(
              label: 'Continue',
              color: kLightGreen,
              onPressed: () {
                Navigator.pushNamed(context, WeightScreen.id);
              },
              icon: Icons.navigate_next,
            ),
          ],
        ),
      ),
    );
  }
}
