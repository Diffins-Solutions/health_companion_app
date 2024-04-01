import 'package:flutter/material.dart';
import 'package:health_companion_app/screens/onboarding/setup_start_screen.dart';
import 'package:health_companion_app/utils/constants.dart';
import '../../widgets/custom_input_field.dart';
import '../../widgets/custom_round_button.dart';

class WelcomeScreen extends StatefulWidget {

  static String id = 'welcome_screen';

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('images/onboarding_pic.png'),
                SizedBox(
                  height: 30,
                ),
                kAppNameHeading,
                SizedBox(
                  height: 30,
                ),
                CustomInputField(
                  textInputType: TextInputType.emailAddress,
                  hint: 'Enter Your Email',
                  onChange: (value) => {
                    setState(() {
                      email = value;
                    })
                  },
                ),
                SizedBox(
                  height: 30,
                ),
                CustomInputField(
                  hint: 'Enter Your Password',
                  onChange: (value) => {
                    setState(() {
                      password = value;
                    })
                  },
                  isPassword: true,
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomRoundButton(
                        label: 'Login',
                        color: kLightGreen,
                        onPressed: () {
                          Navigator.pushNamed(context, SetupStartScreen.id);
                        },
                        isSmall: true),
                    SizedBox( width: 20,),
                    CustomRoundButton(
                        label: 'Sign Up',
                        color: kDarkGreen,
                        onPressed: () {},
                        isSmall: true),
                  ],
                ),

                SizedBox(
                  height: 10,
                ),
                Text(
                  'By continuing, you agree to the Terms of Service\n and acknowledge that you have read the Privacy\n Policy.',
                  style: TextStyle(color: kLightGreen),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
