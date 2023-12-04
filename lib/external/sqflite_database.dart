import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart' show sqfliteFfiInit;
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class SqfliteDatabase {
  static Future<Database> instance() async {
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
          """CREATE TABLE transactions(
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            description TEXT, 
            type TEXT, 
            value REAL, 
            date TEXT
          )""",
        );
      },
      version: 1,
    );
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await SqfliteDatabase.instance();

    await db.insert(table, data, conflictAlgorithm: ConflictAlgorithm.rollback);
  }

  static Future<void> update(
    int id,
    String table,
    Map<String, Object> data,
  ) async {
    final db = await SqfliteDatabase.instance();

    await db.update(
      table,
      data,
      where: '$id = ?',
      whereArgs: [id],
      conflictAlgorithm: ConflictAlgorithm.rollback,
    );
  }

  static Future<void> delete(int id, String table) async {
    final db = await SqfliteDatabase.instance();

    await db.delete(table, where: '$id = ?', whereArgs: [id]);
  }

  static Future<List<Map<String, Object?>>> getAll(String table) async {
    final db = await SqfliteDatabase.instance();

    return db.query(table);
  }
}
