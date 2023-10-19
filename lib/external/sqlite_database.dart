import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart' show sqfliteFfiInit;
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class SQLDatabase {
  static Future<Database> database() async {
    databaseFactoryOrNull = null;

    sqfliteFfiInit();

    // if (Platform.isAndroid || Platform.isIOS) {
    // databaseFactory = databaseFactoryFfi;
    // } else {
    databaseFactoryOrNull = databaseFactoryFfiWeb;
    // }

    final dbPath = await getDatabasesPath();

    return openDatabase(
      join(dbPath, "easyfinances.db"),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE transactions(id INTEGER PRIMARY KEY AUTOINCREMENT, description TEXT, type TEXT, value REAL, date TEXT)",
        );
      },
      version: 1,
    );
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await SQLDatabase.database();

    await db.insert(table, data, conflictAlgorithm: ConflictAlgorithm.rollback);
  }

  static Future<List<Map<String, Object?>>> getAll(String table) async {
    final db = await SQLDatabase.database();

    return db.query(table);
  }
}
