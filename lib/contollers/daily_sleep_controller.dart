import 'package:health_companion_app/models/db_models/daily_sleep.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/db/sqflite_handler.dart';

class DailySleepController {
  static final _dbHandler = DbHandler();
  static final String _today = DateFormat('yyyy-MM-dd').format(DateTime.now());

  static Future<List<DailySleep>> getAllSleepData() async {
    try {
      dynamic result = await _dbHandler.fetchAllData('daily_sleep');
      if (result != null) {
        return List.generate(result.length, (i) {
          return DailySleep.fromObject(result[i]);
        });
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<List<DailySleep>> getYearlySleepData(String year) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String userIdString = prefs.getString('user_id')!;
      int user_id = int.parse(userIdString);
      dynamic result = await _dbHandler.fetchPatternedData('daily_sleep', 'day', year, user_id);
      if (result != null) {
        return List.generate(result.length, (i) {
          return DailySleep.fromObject(result[i]);
        });
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<List<DailySleep>> getMonthlySleepData(String year, String month) async {
    if(month.length == 1) {
      month = "0$month";
    }
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String userIdString = prefs.getString('user_id')!;
      int user_id = int.parse(userIdString);

      dynamic result = await _dbHandler.fetchPatternedData('daily_sleep', 'day', "$year-$month",user_id);
      if (result != null) {
        return List.generate(result.length, (i) {
          return DailySleep.fromObject(result[i]);
        });
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<DailySleep?> getDailySleepData() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String userIdString = prefs.getString('user_id')!;
      int user_id = int.parse(userIdString);
      dynamic result =
      await _dbHandler.fetchFilteredDataFromCurrentUser('daily_sleep', 'day',user_id, [_today]);
      if (result != null) {
        return DailySleep.fromObject(result.first);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future addDailySleepData(DailySleep dailySleep) async {
    try {
      DailySleep? todayData = await getDailySleepData();
      if(todayData == null) {
        await _dbHandler.insert('daily_sleep', dailySleep);
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> updateSleepData(DailySleep dailySleep) async {
    try {
      int result =
      await _dbHandler.updateWithUserId('daily_sleep', dailySleep, 'day', [dailySleep.day, dailySleep.userId]);
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
