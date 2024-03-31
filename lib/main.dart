import 'package:flutter/material.dart';
import 'package:health_companion_app/screens/welcome_screen.dart';
import 'package:health_companion_app/utils/constants.dart';

void main() => runApp(MyHealthApp());

class MyHealthApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        backgroundColor: kBackgroundColor,
        body: SafeArea(child: WelcomeScreen(),),
      ),
    );
  }
}
