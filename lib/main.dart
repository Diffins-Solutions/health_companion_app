import 'package:flutter/material.dart';
import 'package:health_companion_app/screens/onboarding/welcome_screen.dart';
import 'package:health_companion_app/screens/onboarding/setup_start_screen.dart';
import 'package:health_companion_app/screens/onboarding/setup_screen.dart';

void main() => runApp(MyHealthApp());

class MyHealthApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData.dark(),
        initialRoute: WelcomeScreen.id,
        routes: {
          WelcomeScreen.id: (context) => WelcomeScreen(),
          SetupStartScreen.id: (context) => SetupStartScreen(),
          SetupScreen.id: (context) => SetupScreen()
        });
  }
}
