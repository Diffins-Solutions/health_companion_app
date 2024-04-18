import '../models/db_models/user.dart';
import '../services/db/sqflite_handler.dart';

class UserController {
  static final _dbHandler = DbHandler();

  static Future<User> getUser() async {
    try {
      dynamic result = await _dbHandler.fetchData('user');
      return User.fromObject(result);
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

  static Future updateUser(User user) async {
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

}