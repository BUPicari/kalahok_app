import 'dart:io';

import 'package:kalahok_app/helpers/database.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static final DatabaseService dbService = DatabaseService();

  Database? _database;

  Future<Database> get database async {
    return _database ??= await _createDatabase();
  }

  _createDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    String path = join(documentsDirectory.path, DB.dbName);
    var database = await openDatabase(
        path,
        version: 1,
        onCreate: _initDB,
    );

    return database;
  }

  void _initDB(Database database, int version) async {
    await database.execute(DB.surveyCategoryTable);
    await database.execute(DB.surveyTable);
    await database.execute(DB.surveyQuestionnairesTable);
  }
}
