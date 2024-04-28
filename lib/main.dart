import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:health_companion_app/models/local_notifications.dart';
import 'package:health_companion_app/models/steps_notifer.dart';
import 'package:health_companion_app/screens/app_shell.dart';
import 'package:health_companion_app/screens/onboarding/name_screen.dart';
import 'package:health_companion_app/screens/onboarding/welcome_screen.dart';
import 'package:health_companion_app/screens/onboarding/setup_start_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

final _auth = FirebaseAuth.instance;

void main() async {
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
  //Initialize background audio player
  await JustAudioBackground.init(
      androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
      androidNotificationChannelName: 'Audio Playback',
      androidNotificationOngoing: true);
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getInt('counter') == null) {
    await prefs.setInt('counter', 0);
    await prefs.setInt('counterP', 0);
    DateTime today = DateTime.now();
    await prefs.setString('today', today.toString());
    await prefs.setString(
        'yesterday', today.subtract(Duration(days: 1)).toString());
  }

  runApp(MyHealthApp());
}

class MyHealthApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<StepNotifier>(
      create: (context) => StepNotifier(),
      child: MaterialApp(
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
          initialRoute:
          _auth.currentUser == null ? WelcomeScreen.id : AppShell.id,
          routes: {
            WelcomeScreen.id: (context) => WelcomeScreen(),
            SetupStartScreen.id: (context) => SetupStartScreen(),
            NameScreen.id: (context) => NameScreen(),
            AppShell.id: (context) => AppShell(currentIndex: 0),
          }),
    );
  }
}
