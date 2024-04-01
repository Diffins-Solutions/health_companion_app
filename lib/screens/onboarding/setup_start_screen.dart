import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:health_companion_app/utils/constants.dart';
import 'package:health_companion_app/widgets/custom_round_button.dart';
import 'package:health_companion_app/screens/onboarding/setup_screen.dart';

class SetupStartScreen extends StatefulWidget {
  static String id = 'setup_start_screen';

  @override
  State<SetupStartScreen> createState() => _SetupStartScreenState();
}

class _SetupStartScreenState extends State<SetupStartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/setup_image.png'),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "Enhance your app experience. Setup your account to access exclusive features and personalized settings customized to your preferences.",
                textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 35,
              ),
              CustomRoundButton(
                  label: "Setup Account",
                  color: kDarkGreen,
                  onPressed: (){
                    Navigator.pushNamed(context, SetupScreen.id);
                  },
                  isSmall: false,
              ),
              SizedBox(
                height: 45,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(child: Container()), // Empty container to push text to the right
                    GestureDetector(
                      onTap: () => {

                      },
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
            ],
          )
      ),
    );
  }
}
