import 'package:health_companion_app/models/db_models/sleep_target.dart';
import 'package:intl/intl.dart';

import '../services/db/sqflite_handler.dart';

class SleepTargetController {
  static final _dbHandler = DbHandler();
  static String formattedDate = DateFormat.yMMMMd().format(DateTime.now());
  static Map<int, String> weekDays = {
    1: 'M',
    2: 'T',
    3: 'W',
    4: 'Th',
    5: 'F',
    6: 'St',
    7: 'S'
  };
  static String? today = weekDays[DateTime.now().weekday];

  static Future<List<SleepTarget>> getSleepTargets() async {
    try {
      dynamic result = await _dbHandler.fetchAllData('sleep_target');
      if (result != null) {
        return List.generate(result.length, (i) {
          return SleepTarget.fromObject(result[i]);
        });
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<SleepTarget?> getDailySleepData() async {
    try {
      dynamic result =
          await _dbHandler.fetchFilteredData('sleep_target', 'day', [today]);
      if (result != null) {
        return SleepTarget.fromObject(result.first);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future addSleepTargets(List<SleepTarget> targets) async {
    try {
      for (var target in targets) {
        await _dbHandler.insert('sleep_target', target);
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future updateSleepTarget(SleepTarget target) async {
    try {
      int result =
          await _dbHandler.update('sleep_target', target, 'day', [target.day]);
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
