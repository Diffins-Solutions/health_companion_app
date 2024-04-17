import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:health_companion_app/models/local_notifications.dart';
import 'package:health_companion_app/screens/app_shell.dart';
import 'package:health_companion_app/screens/onboarding/height_screen.dart';
import 'package:health_companion_app/screens/onboarding/sleep_schedule_screen.dart';
import 'package:health_companion_app/screens/onboarding/welcome_screen.dart';
import 'package:health_companion_app/screens/onboarding/setup_start_screen.dart';
import 'package:health_companion_app/screens/onboarding/gender_screen.dart';
import 'package:health_companion_app/screens/onboarding/weight_screen.dart';

import 'firebase_options.dart';

final _auth = FirebaseAuth.instance;

void main() async{
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  //splash screen
  await Future.delayed(const Duration(seconds: 1));
  FlutterNativeSplash.remove();
  //initialize local notifications
  await LocalNotifications.init();
  //initialize firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyHealthApp());
}
class MyHealthApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData.dark().copyWith(
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
        initialRoute:
            _auth.currentUser == null ? WelcomeScreen.id : AppShell.id,
        routes: {
          WelcomeScreen.id: (context) => WelcomeScreen(),
          SetupStartScreen.id: (context) => SetupStartScreen(),
          GenderScreen.id: (context) => GenderScreen(),
          HeightScreen.id: (context) => HeightScreen(),
          WeightScreen.id: (context) => WeightScreen(),
          SleepScheduleScreen.id: (context) => SleepScheduleScreen(),
          AppShell.id: (context) => AppShell(currentIndex: 0),
        });
  }
}
