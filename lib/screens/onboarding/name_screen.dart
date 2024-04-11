import 'package:flutter/material.dart';
import 'package:health_companion_app/screens/onboarding/gender_screen.dart';
import 'package:health_companion_app/utils/constants.dart';
import 'package:health_companion_app/widgets/custom_input_field.dart';
import 'package:health_companion_app/widgets/custom_flat_button.dart';

class NameScreen extends StatefulWidget {
  static String id = 'name_screen';

  @override
  State<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
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
                  'What is your name ?',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset('images/name_screen.png'),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 30.0),
              child: Text(
                'Welcome aboard! Please enter your name to kickstart your journey with us.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: CustomInputField(onChange: (value) {}, hint: "Enter your name"),
            ),
            SizedBox(
              height: 50,
            ),
            CustomFlatButton(
              label: 'Continue',
              color: kLightGreen,
              onPressed: () {
                Navigator.pushNamed(context, GenderScreen.id);
              },
              icon: Icons.navigate_next,
            ),
          ],
        ),
      ),
    );
  }
}
