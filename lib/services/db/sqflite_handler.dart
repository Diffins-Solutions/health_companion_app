import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../models/db_models/user.dart';


class DbHandler {

  final int dbVersion = 1;

  Future<Database> get _db async {
    return openDatabase(join(await getDatabasesPath(), "health_companion.db"), version: dbVersion, onCreate: (db, version)=> createDb(db, version));
  }


  FutureOr<void> createDb(Database db, int version) async {
    print('Inside createDb');
    await db.execute('PRAGMA foreign_keys = ON');
    print("Creating user table");
    await db.execute('''
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
    await db.execute('''
          create table sleep_target (  
          day text primary key,
          wakeup text not null,
          sleep text not null)
          ''');
    print("Creating daily target table");
    await db.execute('''
          create table daily_target ( 
          date text primary key, 
          calorie real,
          water real,
          steps integer)
          ''');
    //for 100g
    print("Creating food calorie table");
    await db.execute('''
          create table food_calorie ( 
          food text primary key, 
          calorie real)
          ''');
    print("Creating daily sleep table");
    await db.execute('''
          create table daily_sleep ( 
          id integer primary key autoincrement, 
          day text not null,
          wakeup text,
          sleep text,
          foreign key (day) references sleep_target(day))
          ''');
  }

  Future fetchData(String table) async {
    Database db = await _db;
    List<Map<String, dynamic>> maps = await db.query(
      table,
      limit: 1, // Limit results to 1
    );
    if (maps.isNotEmpty) {
      return maps.first; // Convert map to User object
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
      return maps.first; // Convert map to User object
    } else {
      return null; // Return null if no user found
    }

  }

  Future<int> insert(String table, dynamic data) async {
    Database db = await _db;
    var result = await db.insert(table, data.toMap());
    return result;
  }

  // Future<int> delete(int id) async {
  //   Database db = await this.db;
  //   var result = await db.rawDelete("delete from products where id= $id");
  //   return result;
  // }
  //

  Future update(String table, dynamic data, String field, List<dynamic> args) async {
    Database db = await _db;
    var result = await db.update(table, data.toMap(),
        where: "$field=?", whereArgs: args);
    return result;
  }
}