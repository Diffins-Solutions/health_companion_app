import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:health_companion_app/utils/constants.dart';

class SetupScreen extends StatefulWidget {
  static String id = 'setup_screen';

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        body: SafeArea(
          child: Column(
            children: const [
              Text(
                "Getting Started",
                textAlign: TextAlign.start,
              ),
              Text(
                "Setup your account to continue!"
              )
            ],
          ),
        ),
      ),
    );
  }
}
