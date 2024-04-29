import '../models/db_models/user.dart';
import '../services/db/sqflite_handler.dart';

class UserController {
  static final _dbHandler = DbHandler();

  static Future<User> getCurrentUser(String uid) async {
    try {
      dynamic result = await _dbHandler.fetchFilteredData('user', 'uid', [uid]);
      return User.fromObject(result[0]);
    } catch (e) {
      rethrow;
    }
  }

  static Future addUser(User user) async {
    try {
      int result = await _dbHandler.insert('user', user);
      if (result > 0) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<bool> updateUser(User user) async {
    try {
      int result = await _dbHandler.update('user', user, 'id', [user.id]);
      if (result > 0) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future updateHeartRate (int id, int heartRate) async {
    try{
      int result = await _dbHandler.updateColumn('user', 'id', 'heart', [id, heartRate]);
      if (result > 0) {
        return Future(() => true);
      } else {
        return Future(() => false);
      }
    } catch (e) {
      return Future(() => false);
    }
  }

}