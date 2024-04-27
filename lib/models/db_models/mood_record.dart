class MoodRecord{

  final int? id;
  final String day;
  int sadness;
  int joy;
  int love;
  int anger;
  int fear;
  int surprise;
  int userId;

  MoodRecord({
    this.id,
    required this.day,
    required this.sadness,
    required this.joy,
    required this.love,
    required this.anger,
    required this.fear,
    required this.surprise,
    required this.userId,
  });

  // create table mood (
  // id integer primary key autoincrement,
  // day text not null,
  // day_name text not null,
  // sadness integer not null default 0,
  // joy integer not null default 0,
  // love integer not null default 0,
  // anger integer not null default 0,
  // fear integer not null default 0,
  // surprise integer not null default 0,
  // user_id integer not null,
  // foreign key (user_id) references user(id))
  // ''');


  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    if (id != null) {
      map["id"] = id;
    }
    map["day"] = day;
    map["sadness"] = sadness;
    map["joy"] = joy;
    map["love"] = love;
    map["anger"] = anger;
    map["fear"] = fear;
    map["surprise"] = surprise;
    map["user_id"] = userId;
    return map;
  }

  MoodRecord.fromObject(Map<String, dynamic> o)
      : assert(o != null, 'Input object cannot be null'),
        id = int.tryParse(o["id"].toString())!,
        day = o["day"],
        sadness = int.tryParse(o["sadness"].toString())!,
        joy = int.tryParse(o["joy"].toString())!,
        love = int.tryParse(o["love"].toString())!,
        anger = int.tryParse(o["anger"].toString())!,
        fear = int.tryParse(o["fear"].toString())!,
        surprise = int.tryParse(o["surprise"].toString())!,
        userId = int.tryParse(o["user_id"].toString())!;

  void increaseMood(String mood){
    if(mood == 'sadness'){
      sadness += 1;
    }else if(mood == 'joy'){
      joy += 1;
    }else if(mood == 'love'){
      love += 1;
    }else if(mood == 'anger'){
      anger += 1;
    }else if(mood == 'fear'){
      fear += 1;
    }else if(mood == 'surprise'){
      surprise += 1;
    }

  }

  void printRecord(){
    print('id:  $id, user id: $userId, date: $day, sad: $sadness, joy: $joy, love: $love, anger: $anger, fear: $fear, surprise: $surprise');
  }
}