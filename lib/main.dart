import 'package:flutter/material.dart';
import 'package:health_companion_app/screens/welcome_screen.dart';

void main() => runApp(MyHealthApp());

class MyHealthApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(child: WelcomeScreen(),),
      ),
    );
  }
}
