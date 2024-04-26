import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


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
          mins integer)
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

  Future fetchFilteredData(
      String table, String field, List<dynamic> args) async {
    Database db = await _db;
    List<Map<String, dynamic>> maps =
        await db.query(table, where: "$field=?", whereArgs: args);
    if (maps.isNotEmpty) {
      return maps;
    } else {
      return null; // Return null if no user found
    }
  }

  Future fetchPatternedData(String table, String field, String pattern) async {
    Database db = await _db;
    List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT * FROM $table WHERE $field LIKE ?', ['$pattern-%']);
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
    var result = await db.insert(table, data.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return result;
  }

  Future<int> updateColumn(String table, String primaryKey,
      String columnToUpdate, dynamic data) async {
    Database db = await _db;
    await db.transaction((txn) async {
      // Check if row exists
      final count = await txn
          .rawQuery('SELECT 1 FROM $table WHERE $primaryKey = ?', [data[0]]);
      final rowExists = count.isNotEmpty;
      if (rowExists) {
        // Update existing row
        int result = await txn.rawUpdate(
            'UPDATE $table SET $columnToUpdate = ? WHERE $primaryKey = ?',
            [data[1], data[0]]);
        print('Row updated successfully!');
        return result;
      } else {
        // Insert new row
        int result = await txn
            .insert(table, {primaryKey: data[0], columnToUpdate: data[1]});
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
}
