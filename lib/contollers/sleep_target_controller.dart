
import 'package:health_companion_app/models/db_models/sleep_target.dart';

import '../services/db/sqflite_handler.dart';

class SleepTargetController {
  static final _dbHandler = DbHandler();

  static Future getSleepTargets() async {
    try {
      dynamic result = await _dbHandler.fetchAllData('sleep_target');
      return SleepTarget.fromObject(result);
    } catch (e) {
      return null;
    }
  }

  static Future addSleepTargets(List<SleepTarget> targets) async {
    try {
      for(var target in targets){
        await _dbHandler.insert('sleep_target', target);
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future updateSleepTarget(SleepTarget target) async {
    try {
      int result = await _dbHandler.update('sleep_target', target, 'day', [target.day]);
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