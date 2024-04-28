class DailyTarget{
  String date;
  double? calorie;
  double? water;
  int? steps;
  int userId;

  DailyTarget({required this.date, this.calorie, this.water, this.steps, required this.userId});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map["date"] = date;
    map['user_id'] = userId;
    if(calorie != null) {
      map["calorie"] = calorie;
    }
    if(water != null){
      map['water'] = water;
    }
    if(steps != null){
      map['steps'] = steps;
    }
    return map;
  }

  DailyTarget.fromObject(Map<String, dynamic> o)
      : date = o['date'],
        calorie= o['calorie'],
        water = o['water'],
        steps = o['steps'],
        userId = o['user_id'];

}