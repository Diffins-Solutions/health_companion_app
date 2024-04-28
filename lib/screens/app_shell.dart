// AppShell.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_companion_app/contollers/daily_sleep_controller.dart';
import 'package:health_companion_app/contollers/sleep_target_controller.dart';
import 'package:health_companion_app/models/db_models/daily_sleep.dart';
import 'package:health_companion_app/models/db_models/sleep_target.dart';
import 'package:health_companion_app/models/db_models/user.dart';
import 'package:health_companion_app/screens/health_tips/health_tips_screen.dart';
import 'package:health_companion_app/screens/onboarding/welcome_screen.dart';
import 'package:health_companion_app/screens/sleep/sleep_screen.dart';
import 'package:health_companion_app/screens/medication/medication_screen.dart';
import 'package:health_companion_app/utils/signout.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:health_companion_app/contollers/user_controller.dart';
import 'package:health_companion_app/utils/time_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  int sleep = 0;
  late List<String>? _healthTipsKeyWords = ["general"];

  void getUserDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString('uid');
    if(uid == null){
      await SignOutUtil.signOut();
      Navigator.pushNamedAndRemoveUntil(context, WelcomeScreen.id, (Route<dynamic> route) => false);
      return;
    }
    User user;
    try{
       user = await UserController.getCurrentUser(uid);
    }catch(e){
      await SignOutUtil.signOut();
      Navigator.pushNamedAndRemoveUntil(context, WelcomeScreen.id, (Route<dynamic> route) => false);
      return;
    }
    await prefs.setString('user_id', user.id.toString());
    DailySleep? dailySleepData = await DailySleepController.getDailySleepData();
    SleepTarget? sleepTargetData = await SleepTargetController.getDailySleepData();
    if (dailySleepData == null) {
      sleep = getTimeInBedMins(convertTime(sleepTargetData!.sleep), convertTime(sleepTargetData!.wakeup));
    } else {
      sleep = dailySleepData.mins;
    }
    if (user != null) {
      setState(() {
        name = user.name;
      });
      if (_selectedIndex == 2) {
        List<String> recommendations = HealthTipsModel.getRecomendedHealthTips(user, (sleep/60).floor());
        if (widget.healthTipsKeyWords == null && recommendations.isNotEmpty) {
          _healthTipsKeyWords = _healthTipsKeyWords! + recommendations;
        } else {
          _healthTipsKeyWords = _healthTipsKeyWords! + widget.healthTipsKeyWords!;
          _healthTipsKeyWords = _healthTipsKeyWords! + recommendations;
        }
      }
    }
  }
  

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.currentIndex; // Get initial index
    getUserDetails();
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
