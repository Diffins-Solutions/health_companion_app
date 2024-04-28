import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_companion_app/screens/app_shell.dart';
import 'package:health_companion_app/screens/onboarding/setup_start_screen.dart';
import 'package:health_companion_app/utils/constants.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/custom_input_field.dart';
import '../../widgets/custom_round_button.dart';

class WelcomeScreen extends StatefulWidget {

  static String id = 'welcome_screen';

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  final _auth = FirebaseAuth.instance;
  String email = '';
  String password = '';
  double opacity = 1;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: Center(
          child: ModalProgressHUD(
            inAsyncCall: _saving,
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
                          onPressed: () async {
                            setState(() {
                              _saving = true;
                            });

                            try {
                              final user = await _auth.signInWithEmailAndPassword(
                                  email: email, password: password);
                              if (user != null) {
                                final String uid = await _auth.currentUser!.uid;
                                final SharedPreferences prefs = await SharedPreferences.getInstance();
                                await prefs.setString('uid', uid);
                                Navigator.pushNamed(context, AppShell.id);
                              }

                              setState(() {
                                _saving = false;
                              });

                            } catch (e) {
                              String error = e.toString();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(error.split(']')[1])));
                              setState(() {
                                _saving = false;
                              });
                            }

                          },
                          isSmall: true),
                      SizedBox( width: 20,),
                      CustomRoundButton(
                          label: 'Sign Up',
                          color: kDarkGreen,
                          onPressed: () async{
                            setState(() {
                              _saving = true;
                            });

                            try {
                              final newUser = await _auth.createUserWithEmailAndPassword(
                                  email: email, password: password);
                              if (newUser != null) {
                                final String uid = await _auth.currentUser!.uid;
                                final SharedPreferences prefs = await SharedPreferences.getInstance();
                                await prefs.setString('uid', uid);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SetupStartScreen(
                                      previousData: {
                                        'uid': uid,
                                      },
                                    ),
                                  ),
                                );
                              }

                              setState(() {
                                _saving = false;
                              });

                            } catch (e) {
                              String error = e.toString();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(error.split(']')[1])));
                              setState(() {
                                _saving = false;
                              });
                            }

                          },
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
      ),
    );
  }
}
