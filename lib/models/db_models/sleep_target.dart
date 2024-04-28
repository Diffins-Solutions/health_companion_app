class SleepTarget {
  String day;
  String wakeup;
  String sleep;
  int userId;

  SleepTarget({required this.day, required this.sleep, required this.wakeup, required this.userId});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map["day"] = day;
    map["wakeup"] = wakeup;
    map["sleep"] = sleep;
    map['user_id'] = userId;

    return map;
  }

  SleepTarget.fromObject(Map<String, dynamic> o)
      : day = o['day'],
        wakeup = o['wakeup'],
        sleep = o['sleep'],
        userId = o['user_id'];
}
