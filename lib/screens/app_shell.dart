// AppShell.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_companion_app/models/db_models/user.dart';
import 'package:health_companion_app/screens/health_tips/health_tips_screen.dart';
import 'package:health_companion_app/screens/sleep/sleep_screen.dart';
import 'package:health_companion_app/screens/medication/medication_screen.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:health_companion_app/contollers/user_controller.dart';

import '../models/health_tips_model.dart';
import '../utils/constants.dart';
import '../widgets/custom_bottom_bar.dart';
import '../widgets/welcome_text.dart';
import 'landing/landing_screen.dart';
import 'mood/mood_screen.dart';

class AppShell extends StatefulWidget {
  final int currentIndex;
  final AudioPlayer? audioPlayer;
  static final String id = 'app_shell';
  final List<String>? dassScores;
  final List<String>? healthTipsKeyWords;

  const AppShell({Key? key, required this.currentIndex, this.audioPlayer, this.dassScores, this.healthTipsKeyWords})
      : super(key: key);

  @override
  _AppShellState createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0; // Inter  nal state for selected tab
  String formattedDate = DateFormat.yMMMMd().format(DateTime.now());
  String name = 'Default user';
  late List<String>? _healthTipsKeyWords = ["general"];

  void getUser() async {
    User user = await UserController.getUser();
    if (user != null) {
      setState(() {
        name = user.name;
      });
      if (_selectedIndex == 2) {
        List<String> recommendations = HealthTipsModel.getRecomendedHealthTips(user);
        if (widget.healthTipsKeyWords == null && recommendations.isNotEmpty) {
          _healthTipsKeyWords = _healthTipsKeyWords! + recommendations;
        } else {
          _healthTipsKeyWords = _healthTipsKeyWords! + widget.healthTipsKeyWords!;
          _healthTipsKeyWords = _healthTipsKeyWords! + recommendations;
        }
      }
    }
  }
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
    getUser();
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
        return MoodScreen(dassScores: widget.dassScores);
      case 2:
        return HealthTipsScreen(healthTipsKeyWords: _healthTipsKeyWords,);
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
      body: SafeArea(
        child: Column(
          children: [
            WelcomeText(
              name: name,
              today: formattedDate,
              isLandingPage: _selectedIndex == 0,
              isMoodPage: _selectedIndex == 1,
            ),
            _buildScreen(_selectedIndex),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _selectedIndex,
        onTap: navigateToScreen,
        // ... other bottom bar properties
      ),
    );
  }
}
