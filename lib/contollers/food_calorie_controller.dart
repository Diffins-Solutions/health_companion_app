import 'package:health_companion_app/models/db_models/food_calorie.dart';

import '../services/db/sqflite_handler.dart';

class FoodCalorieController{
  static final _dbHandler = DbHandler();

  static Future<List<FoodCalorie>> getFoodCalories() async {
    try {
      dynamic result = await _dbHandler.fetchAllData('food_calorie');
      return List.generate(result.length, (i) {
        return FoodCalorie.fromObject(result[i]);
      });
    } catch (e) {
      return [];
    }
  }
}