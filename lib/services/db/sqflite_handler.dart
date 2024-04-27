import 'dart:async';

import 'package:health_companion_app/models/db_models/mood_record.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../models/db_models/user.dart';

class DbHandler {
  final int dbVersion = 1;

  Future<Database> get _db async {
    return openDatabase(join(await getDatabasesPath(), "health_companion.db"),
        version: dbVersion, onCreate: (db, version) => createDb(db, version));
  }

  FutureOr<void> createDb(Database db, int version) async {
    await db.transaction((txn) async {
      await txn.execute('PRAGMA foreign_keys = ON');
      print("Creating user table");
      await txn.execute('''
          create table user ( 
          id integer primary key autoincrement, 
          name text not null,
          gender text not null,
          age integer not null,
          height integer not null,
          weight integer not null,
          steps integer not null,
          heart integer)
          ''');
      print("Creating sleep target table");
      await txn.execute('''
          create table sleep_target (  
          day text primary key,
          wakeup text not null,
          sleep text not null)
          ''');
      print("Creating daily target table");
      await txn.execute('''
          create table daily_target ( 
          date text primary key, 
          calorie real,
          water real,
          steps integer)
          ''');
      //kCal for for 100g
      print("Creating food calorie table");
      await txn.execute('''
          create table food_calorie ( 
          food text primary key, 
          calorie real)
          ''');
      print("Creating daily sleep table");
      await txn.execute('''
          create table daily_sleep ( 
          id integer primary key autoincrement, 
          day text not null,
          wakeup text,
          sleep text,
          foreign key (day) references sleep_target(day))
          ''');

      /// 1. sadness => 🙁
      /// 2. joy => 😀
      /// 3. love => 🥰
      /// 4. anger => 😡
      /// 5. fear => 😰
      /// 6. surprise => 😲
      print("Creating mood table");
      await txn.execute('''
          create table mood ( 
          id integer primary key autoincrement, 
          day text not null,
          sadness integer not null default 0,
          joy integer not null default 0,
          love integer not null default 0,
          anger integer not null default 0,
          fear integer not null default 0,
          surprise integer not null default 0,
          user_id integer not null,
          foreign key (user_id) references user(id))
          ''');
      print("Inserting data into food_calorie");
      await txn.execute('''
          insert into food_calorie (food, calorie)
          values
          ('Apple', 43),
          ('Apricot', 31),
          ('Avocado', 171),
          ('Banana', 81),
          ('Blackberries', 21),
          ('Cherries', 63),
          ('Clementines', 41),
          ('Fresh Coconut', 351),
          ('Cranberries', 15),
          ('Cucumber', 14),
          ('Dried dates', 235),
          ('Fresh figs', 43),
          ('Grapefruit', 34),
          ('Kiwi', 32),
          ('Lemon', 19),
          ('Lime', 9),
          ('Lychee', 58),
          ('Mango', 48),
          ('Corn', 54),
          ('Cabbage', 27),
          ('Carrot', 34),
          ('Broccoli', 34),
          ('Beetroot', 36),
          ('Potato', 77),
          ('Pumpkin', 13),
          ('Pork bacon', 287),
          ('Lean beef mince', 169),
          ('Chicken breast', 106),
          ('Chicken wings', 110),
          ('Chicken thighs', 158),
          ('Duck breast', 165),
          ('Lamb steak', 155),
          ('Lamb liver', 137),
          ('Chicken sausage', 175),
          ('Turkey sausage (turkey)', 167),
          ('Pork sausage', 301),
          ('Quail eggs', 158),
          ('Dark meat turkey', 184),
          ('White meat turkey', 104),
          ('Venison', 103),
          ('Butter', 744),
          ('Eggs', 131),
          ('Yogurt', 79),
          ('Goats Milk', 61),
          ('Ice cream', 189),
          ('Milk skimmed', 34),
          ('Milk whole', 63),
          ('Bread white',	275),
          ('Bread wholemeal', 217),
          ('Pasta white', 353),
          ('Pasta wholewheat', 266),
          ('Rice brown', 131),
          ('Rice white', 117),
          ('Coconut oil', 899),
          ('Vegetable oil', 825),
          ('Corn oil', 829),
          ('Apple juice', 43),
          ('Coffee black', 2),
          ('Lemonade', 19),
          ('Orange juice', 40),
          ('Tea with no milk', 2),
          ('Tea with skimmed milk', 12),
          ('Tea with whole milk', 22);
          ''');
    });

  }

  Future fetchData(String table) async {
    Database db = await _db;
    List<Map<String, dynamic>> maps = await db.query(
      table,
      limit: 1, // Limit results to 1
    );
    if (maps.isNotEmpty) {
      return maps.first;
    } else {
      return null; // Return null if no user found
    }
  }

  Future fetchFilteredData(String table, String field, List<dynamic> args) async {
    Database db = await _db;
    List<Map<String, dynamic>> maps = await db.query(
      table,
        where: "$field=?",
        whereArgs: args
    );
    if (maps.isNotEmpty) {
      return maps;
    } else {
      return null; // Return null if no user found
    }
  }

  Future fetchAllData(String table) async {
    Database db = await _db;
    List<Map<String, dynamic>> maps = await db.query(
      table,
    );
    if (maps.isNotEmpty) {
      return maps; // Convert map to User object
    } else {
      return null; // Return null if no user found
    }
  }

  Future<int> insert(String table, dynamic data) async {
    Database db = await _db;
    var result = await db.insert(table, data.toMap());
    return result;
  }

  Future<int> insertOrUpdate(String table, dynamic data) async {
    Database db = await _db;
    var result = await db.insert(table, data.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    return result;
  }

  Future<int> updateColumn(String table, String primaryKey, String columnToUpdate, dynamic data) async {
    Database db = await _db;
    await db.transaction((txn) async {
      // Check if row exists
      final count = await txn.rawQuery('SELECT 1 FROM $table WHERE $primaryKey = ?', [data[0]]);
      final rowExists = count.isNotEmpty;
      if (rowExists) {
        // Update existing row
        int result = await txn.rawUpdate(
            'UPDATE $table SET $columnToUpdate = ? WHERE $primaryKey = ?',
            [data[1],data[0]]);
        print('Row updated successfully!');
        return result;
      } else {
        // Insert new row
        int result = await txn.insert(table, {primaryKey: data[0], columnToUpdate: data[1]});
        print('Row inserted successfully!');
        return result;
      }
    });
    return 0;
  }
  // Future<int> delete(int id) async {
  //   Database db = await this.db;
  //   var result = await db.rawDelete("delete from products where id= $id");
  //   return result;
  // }
  //

  Future update(
      String table, dynamic data, String field, List<dynamic> args) async {
    Database db = await _db;
    var result = await db.update(table, data.toMap(),
        where: "$field=?", whereArgs: args);
    return result;
  }

  Future<int> insertMood(int userId, int mood) async {
    Database db = await _db;
    int timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000; // Get current Unix timestamp
    int result = await db.insert(
      'mood',
      {'day': timestamp, 'mood': mood, 'user_id': userId},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return result;
  }

  Future fetchFilteredDataUsingMultipleFields(String table, Map<String, dynamic> fieldArgs) async {
    Database db = await _db;

    // Construct the 'where' clause
    String whereString = "";
    List<dynamic> whereArgs = [];
    fieldArgs.forEach((key, value) {
      if (whereString.isNotEmpty) whereString += " AND ";
      whereString += "$key=?";
      whereArgs.add(value);
    });

    List<Map<String, dynamic>> maps = await db.query(
        table,
        where: whereString,
        whereArgs: whereArgs
    );

    if (maps.isNotEmpty) {
      return maps;
    } else {
      return null; // Return null if no data found
    }
  }

  Future<List<MoodRecord>> getRecordsThisWeek(int userId) async {
    try {
      Database db = await _db;
      DateTime now = DateTime.now();
      DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      String formattedDate = DateFormat('yyyy-MM-dd').format(startOfWeek);

      List<Map<String, dynamic>> maps = await db.query(
        'mood',
        where: "day >= ? AND user_id = ?",
        whereArgs: [formattedDate, userId],
      );

      return List.generate(maps.length, (i) => MoodRecord.fromObject(maps[i]));
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<MoodRecord>> getTodayRecord(int userId) async {
    try {
      Database db = await _db;
      String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

      List<Map<String, dynamic>> maps = await db.query(
        'mood',
        where: "day >= ? AND user_id = ?",
        whereArgs: [today, userId],
      );

      return List.generate(maps.length, (i) => MoodRecord.fromObject(maps[i]));
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<MoodRecord>> getRecordsThisMonth(int userId) async {
    try {
      Database db = await _db;
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM').format(now) + '-01';

      List<Map<String, dynamic>> maps = await db.query(
        'mood',
        where: "day >= ? AND user_id = ?",
        whereArgs: [formattedDate, userId],
      );

      return List.generate(maps.length, (i) => MoodRecord.fromObject(maps[i]));
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<MoodRecord>> getRecordsThisYear(int userId) async {
    try {
      Database db = await _db;
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy').format(now) + '-01-01';

      List<Map<String, dynamic>> maps = await db.query(
        'mood',
        where: "day >= ? AND user_id = ?",
        whereArgs: [formattedDate, userId],
      );

      return List.generate(maps.length, (i) => MoodRecord.fromObject(maps[i]));
    } catch (e) {
      print(e);
      rethrow;
    }
  }




}
