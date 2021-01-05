import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

import '../models/database_exception.dart';

class DBHelper {
  static final databaseName = 'accounts.db';
  static final tableName = 'account';

  static Future<sql.Database> openDatabase() async {
    try {
      var dbPath = await sql.getDatabasesPath();
      dbPath = path.join(dbPath, DBHelper.databaseName);
      var database = await sql.openDatabase(
        dbPath,
        version: 1,
        onCreate: (db, version) async {
          print('Creating new table');
          db.execute(
              'CREATE TABLE ${DBHelper.tableName} (date TEXT PRIMARY KEY, url TEXT, username TEXT, email TEXT, password TEXT, about TEXT, imageUrl TEXT)');
        },
      );

      return database;
    } catch (error) {
      throw DatabaseException("Unable to open database");
    }
  }

  static Future<int> insert({
    @required DateTime date,
    String url,
    String username,
    String email,
    String password,
    String about,
    String imageUrl,
  }) async {
    var account = {
      'date': date.toIso8601String(), //Primary key
      'url': url ?? '',
      'username': username ?? '',
      'email': email ?? '',
      'password': password ?? '',
      'about': about ?? '',
      'imageUrl': imageUrl ?? '',
    };
    try {
      var database = await DBHelper.openDatabase();
      var response = await database.insert(DBHelper.tableName, account,
          conflictAlgorithm: sql.ConflictAlgorithm.replace);
      return response;
    } on DatabaseException catch (error) {
      throw (error);
    } catch (error) {
      throw DatabaseException('Insertion Failed');
    }
  }

  static Future<int> delete(DateTime date) async {
    try {
      var database = await DBHelper.openDatabase();

      return await database.delete(DBHelper.tableName,
          where: 'date = ?', whereArgs: [date.toIso8601String()]);
    } on DatabaseException catch (error) {
      throw error;
    } catch (error) {
      throw DatabaseException('Unable to delete account');
    }
  }

  static Future<List<Map<String, dynamic>>> getAccountsFromDB() async {
    try {
      var database = await DBHelper.openDatabase();
      if (database == null) throw DatabaseException('Unable to open database.');
      List<Map<String, dynamic>> accounts =
          await database.query(DBHelper.tableName);
      return accounts;
    } on DatabaseException catch (error) {
      throw error;
    } catch (error) {
      throw DatabaseException("Unable to featch data");
    }
  }
}
