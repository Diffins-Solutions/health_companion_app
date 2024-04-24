import 'package:health_companion_app/models/db_models/daily_sleep.dart';
import 'package:intl/intl.dart';
import '../services/db/sqflite_handler.dart';

class DailySleepController {
  static final _dbHandler = DbHandler();

  static Future<List<DailySleep>> getYearlySleepData(String year) async {
    try {
      dynamic result = await _dbHandler.fetchPatternedData('daily_sleep', 'day', year);
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
    try {
      dynamic result = await _dbHandler.fetchPatternedData('daily_sleep', 'day', "$year-$month");
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

  Future<DailySleep?> getDailySleepData() async {
    try {
      dynamic result =
      await _dbHandler.fetchFilteredData('daily_sleep', 'day', [_today]);
      if (result != null) {
        return DailySleep.fromObject(result.first);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future addSleepData(DailySleep dailySleep) async {
    try {
      await _dbHandler.insert('daily_sleep', dailySleep);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future updateSleepData(DailySleep dailySleep) async {
    try {
      int result =
      await _dbHandler.update('daily_sleep', dailySleep, 'day', [dailySleep.day]);
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
