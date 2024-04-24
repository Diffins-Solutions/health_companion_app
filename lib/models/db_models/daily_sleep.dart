class DailySleep {
  String day;
  int mins;

  DailySleep({required this.day, required this.mins});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map["day"] = day;
    map["mins"] = mins;

    return map;
  }

  DailySleep.fromObject(Map<String, dynamic> o)
      : day = o['day'],
        mins = o['mins'];
}
