class FoodCalorie {
  String food;
  double calorie;

  FoodCalorie({required this.food, required this.calorie});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map["food"] = food;
    map["calorie"] = calorie;

    return map;
  }

  FoodCalorie.fromObject(Map<String, dynamic> o)
      : food = o['food'],
        calorie= o["calorie"];
}
