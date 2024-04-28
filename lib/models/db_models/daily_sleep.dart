class DailySleep {
  String day;
  int mins;
  int userId;

  DailySleep({required this.day, required this.mins, required this.userId});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map["day"] = day;
    map["mins"] = mins;
    map["user_id"] = userId;

    return map;
  }

  DailySleep.fromObject(Map<String, dynamic> o)
      : day = o['day'],
        mins = o['mins'],
        userId = o['user_id'];
}
