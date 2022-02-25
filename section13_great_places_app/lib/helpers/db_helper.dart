import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DBHelper {
  static Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
      path.join(dbPath, 'user_places.db'),
      // bắt buộc phải trùng tên nhé!!!
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, loc_lat REAL, loc_lng REAL, address TEXT)');
        // câu lệnh để chạy hàm tạo table
      },
      version: 1,
    );
    // so when it doesn't find that file, it will create the database and
    // therefore, open database gives us
    // another argument which we can specify, the onCreate argument.
  }

  static Future<void> insert(String table, Map<String, Object?> data) async {
    final db = await DBHelper.database();
    await db.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
      // if we're trying to insert data for an ID which already is in the
      // database table, then we'll override the existing entry, the existing
      // record with the new data.
    );
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelper.database();
    return db.query(table);
    // return Future<List<Map>>
  }
}
