import 'package:health_companion_app/models/db_models/daily_target.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/db/sqflite_handler.dart';

class DailyTargetController {
  static final String _today = DateFormat.yMMMMd().format(DateTime.now());
  static final _dbHandler = DbHandler();

  static Future<DailyTarget?> getDailyTarget() async {
    try {
      print('Get daily target');
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String userIdString = prefs.getString('user_id')!;
      int user_id = int.parse(userIdString);
      dynamic result =
      await _dbHandler.fetchFilteredDataFromCurrentUser('daily_target', 'date', user_id,[_today]);
      print('Target $result');
      if (result != null) {
        return DailyTarget.fromObject(result.first);
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future addOrUpdateDailyTarget(DailyTarget dailyTarget) async {
    try {
      int result = await _dbHandler.insertOrUpdate('daily_target', dailyTarget);
      if (result > 0) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future addOrUpdateSteps(String date, int steps) async {
    print('Adding steps $date : $steps');
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String userIdString = prefs.getString('user_id')!;
      int user_id = int.parse(userIdString);

      int result = await _dbHandler.updateColumnForCurrentUser('daily_target', user_id, 'date', 'steps', [date, steps]);
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
