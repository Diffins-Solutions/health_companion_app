
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignOutUtil{
  static Future<void> signOut() async{
    final _auth = FirebaseAuth.instance;
    await _auth.signOut();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('uid');
    prefs.remove('user_id');
  }
}