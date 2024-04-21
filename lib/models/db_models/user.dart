import '../../services/db/sqflite_handler.dart';

class User {
  final int? id;
  final String name;
  final String gender;
  final int age;
  final int height;
  final int weight;
  final int steps;
  final int? heart; // Optional heart rate

  User({
    this.id,
    required this.name,
    required this.age,
    required this.height,
    required this.weight,
    required this.gender,
    required this.steps,
    this.heart,
  }) : assert(age >= 0, 'Age cannot be negative'); // Add assertion for age

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    if (id != null) {
      map["id"] = id;
    }
    map["name"] = name;
    map["gender"] = gender;
    map["age"] = age;
    map["height"] = height;
    map["weight"] = weight;
    map["steps"] = steps;
    if (heart != null) {
      map["heart"] = heart;
    }
    return map;
  }

  User.fromObject(Map<String, dynamic> o)
      : assert(o != null, 'Input object cannot be null'),
        id = int.tryParse(o["id"].toString())!,
        name = o["name"],
        gender = o["gender"],
        age = int.tryParse(o["age"].toString())!,
        height = int.tryParse(o["height"].toString())!,
        weight = int.tryParse(o["weight"].toString())!,
        steps = int.tryParse(o["steps"].toString())!,
        heart = int.tryParse(o["heart"].toString()) {
    if (age < 0) {
      throw ArgumentError(
          'Age cannot be negative'); // Throw exception for invalid age
    }
  }

}
