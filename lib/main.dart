import 'package:flutter/material.dart';
import 'package:health_companion_app/models/local_notifications.dart';
import 'package:health_companion_app/screens/app_shell.dart';
import 'package:health_companion_app/screens/landing/landing_screen.dart';
import 'package:health_companion_app/screens/onboarding/daily_move_goal.dart';
import 'package:health_companion_app/screens/onboarding/height_screen.dart';
import 'package:health_companion_app/screens/onboarding/name_screen.dart';
import 'package:health_companion_app/screens/onboarding/sleep_schedule_screen.dart';
import 'package:health_companion_app/screens/onboarding/welcome_screen.dart';
import 'package:health_companion_app/screens/onboarding/setup_start_screen.dart';
import 'package:health_companion_app/screens/onboarding/gender_screen.dart';
import 'package:health_companion_app/screens/onboarding/weight_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotifications.init();
  runApp(MyHealthApp());
}

class MyHealthApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData.dark().copyWith(
          textTheme: Typography().white.apply(fontFamily: 'Hind-Regular'),
          inputDecorationTheme: InputDecorationTheme(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.transparent,
                width: 0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.transparent,
                width: 0,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.transparent,
                width: 0,
              ),
            ),
            filled: true,
            fillColor: Color(0xff334E4B),
          ),
        ),
        initialRoute: WelcomeScreen.id,
        routes: {
          WelcomeScreen.id: (context) => WelcomeScreen(),
          SetupStartScreen.id: (context) => SetupStartScreen(),
          NameScreen.id: (context) => NameScreen(),
          GenderScreen.id: (context) => GenderScreen(),
          HeightScreen.id: (context) => HeightScreen(),
          WeightScreen.id: (context) => WeightScreen(),
          SleepScheduleScreen.id: (context) => SleepScheduleScreen(),
          LandingScreen.id: (context) => LandingScreen(),
          DailyMoveGoal.id: (context) => DailyMoveGoal(),
          AppShell.id: (context) => AppShell(currentIndex: 0),
        });
  }
}
