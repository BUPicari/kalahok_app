import 'dart:io';

import 'package:kalahok_app/helpers/database.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static final DatabaseService dbService = DatabaseService();

  late Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _createDatabase();
    return _database;
  }

  _createDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    String path = join(documentsDirectory.path, DB.name);
    var database = await openDatabase(
        path,
        version: 1,
        onCreate: _initDB,
    );

    return database;
  }

  void _initDB(Database database, int version) async {
    await database.execute(DB.table);
  }
}
