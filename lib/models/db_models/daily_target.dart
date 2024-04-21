class DailyTarget{
  String date;
  double? calorie;
  double? water;
  int? steps;

  DailyTarget({required this.date, this.calorie, this.water, this.steps});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map["date"] = date;
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
        steps = o['steps'];

}