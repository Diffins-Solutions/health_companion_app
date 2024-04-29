import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../contollers/daily_target_controller.dart';

class SignOutUtil {
  static Future<void> signOut() async {
    final _auth = FirebaseAuth.instance;
    await _auth.signOut();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('uid');
    prefs.remove('user_id');
    _handleStepCount(prefs);
  }

  static Future<void> _handleStepCount(SharedPreferences sp) async {
    await DailyTargetController.addOrUpdateSteps(
        DateFormat.yMMMMd().format(DateTime.parse(sp.getString('today')!)),
        sp.getInt('counter')!);
    await sp.remove('counter');
    await sp.remove('counterP');
    await sp.remove('today');
    await sp.remove('yesterday');
  }
}
