// AppShell.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_companion_app/models/db_models/user.dart';
import 'package:health_companion_app/screens/health_tips/health_tips_screen.dart';
import 'package:health_companion_app/screens/sleep/sleep_screen.dart';
import 'package:health_companion_app/screens/medication/medication_screen.dart';
import 'package:just_audio/just_audio.dart';
import 'package:health_companion_app/services/db/sqflite_handler.dart';
import 'package:health_companion_app/utils/enums.dart';

import '../utils/constants.dart';
import '../widgets/custom_bottom_bar.dart';
import 'landing/landing_screen.dart';
import 'mood/mood_screen.dart';

class AppShell extends StatefulWidget {
  final int currentIndex;
  final AudioPlayer? audioPlayer;
  static final String id = 'app_shell';

  const AppShell({Key? key, required this.currentIndex, this.audioPlayer})
      : super(key: key);

  @override
  _AppShellState createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0; // Inter  nal state for selected tab


  // Future getUser() async{
  //   var dbHandler = DbHandler();
  //   User user = await dbHandler.getUser();
  //   print('get User: ${user.name}');
  // }
  //
  // Future addUser() async{
  //   var dbHandler = DbHandler();
  //   int user = (await dbHandler.insert(User(name: 'Nethmi', age: 25, height: 163, weight: 62, gender: Gender.female.toString(), steps: 3000))) ;
  //   print('User is: $user');
  // }


  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.currentIndex; // Get initial index
    //getUser();
    //addUser();
  }

  void navigateToScreen(int index) {
    setState(() => _selectedIndex = index);
    // Handle navigation logic (push/pop routes, etc.)
  }

  Widget _buildScreen(int index) {
    switch (index) {
      case 0:
        return LandingScreen();
      case 1:
        return MoodScreen();
      case 2:
        return HealthTipsScreen();
      case 3:
        return SleepScreen(
          audioPlayer: widget.audioPlayer,
        );
      case 4:
        return MedicationScreen();
      default:
        return Container(); // Handle invalid index
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: _buildScreen(_selectedIndex),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _selectedIndex,
        onTap: navigateToScreen,
        // ... other bottom bar properties
      ),
    );
  }
}
