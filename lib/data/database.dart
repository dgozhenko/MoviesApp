import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

const movieTable = 'Movie';

class DatabaseProvider {
  static final DatabaseProvider databaseProvider = DatabaseProvider();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await createDatabase();
    return _database!;
  }

  createDatabase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "MovieApp.db");
    var database = await openDatabase(path,
        version: 1, onCreate: initDb, onUpgrade: onUpgrade);
    return database;
  }

  void onUpgrade(Database database, int oldVersion, int newVersion) {
    if (newVersion > oldVersion) {}
  }

  Future<void> initDb(Database database, int version) async {
    await database.execute("CREATE TABLE $movieTable ("
        "id INTEGER PRIMARY KEY, "
        "title TEXT, "
        "is_watched INTEGER, "
        "image_url TEXT, "
        "creation_time INTEGET "
        ")");
  }
}
