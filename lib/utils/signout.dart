
import 'package:firebase_auth/firebase_auth.dart';

class SignOutUtil{
  static Future<void> signOut() async{
    final _auth = FirebaseAuth.instance;
    await _auth.signOut();
  }
}