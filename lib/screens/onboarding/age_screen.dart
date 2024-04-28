import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:health_companion_app/screens/onboarding/gender_screen.dart';
import 'package:health_companion_app/utils/constants.dart';
import 'package:health_companion_app/widgets/custom_flat_button.dart';

class AgeScreen extends StatefulWidget {
  static String id = 'age_screen';

  final Map<String, dynamic> previousData;

  AgeScreen({required this.previousData});

  @override
  State<AgeScreen> createState() => _AgeScreenState();
}

class _AgeScreenState extends State<AgeScreen> {
  int age = 25;

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
                      'How old are you ?',
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Image.asset('images/age_screen.jpg'),
                SizedBox(
                  height: 75,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        setState(() {
                          age--;
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
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      age.toString(),
                      style: TextStyle(
                        fontSize: 70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    MaterialButton(
                      onPressed: () {
                        setState(() {
                          age++;
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
                SizedBox(
                  height: 80,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "Age is your unique timeline, a personal journey. Sharing it helps us tailor health"
                    " advice, turning years into milestones "
                    "of wellness. Let’s navigate this health odyssey together, one year at a time.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
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
                    builder: (context) => GenderScreen(
                      previousData: {
                        'name': widget.previousData['name'],
                        'age': age
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
