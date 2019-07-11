import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

var _version = 1;
Database db;

Future<Database> getDB() async {
  if (db == null) {
    var dataBasePath = await getDatabasesPath();
    var path = join(dataBasePath, "account_book.db");
    db = await openDatabase(path, version: _version,
        onCreate: (Database db, int version) async {
      //创建账目数据库
      await db.execute("""
    CREATE TABLE account (
        id TEXT PRIMARY KEY,
        dateTime INTEGER,
        type INTEGER,
        isDelete INTEGER,
        money REAL
        )
        """);
    });
  }
  return db;
}
