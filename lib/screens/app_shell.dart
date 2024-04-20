// AppShell.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_companion_app/screens/health_tips/health_tips_screen.dart';
import 'package:health_companion_app/screens/sleep/sleep_screen.dart';
import 'package:health_companion_app/screens/medication/medication_screen.dart';
import 'package:just_audio/just_audio.dart';

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

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.currentIndex; // Get initial index
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
      resizeToAvoidBottomInset: false,
      body: _buildScreen(_selectedIndex),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _selectedIndex,
        onTap: navigateToScreen,
        // ... other bottom bar properties
      ),
    );
  }
}
