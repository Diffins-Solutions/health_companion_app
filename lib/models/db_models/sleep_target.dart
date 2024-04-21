class SleepTarget {
  String day;
  String wakeup;
  String sleep;

  SleepTarget({required this.day, required this.sleep, required this.wakeup});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map["day"] = day;
    map["wakeup"] = wakeup;
    map["sleep"] = sleep;

    return map;
  }

  SleepTarget.fromObject(Map<String, dynamic> o)
      : day = o['day'],
        wakeup = o['wakeup'],
        sleep = o['sleep'];
}
