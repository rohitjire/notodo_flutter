import 'package:notodo/model/nodoitem.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  final String tableName = 'Nodotbl';
  final String columnId = 'id';
  final String columnItemName = 'itemName';
  final String columnDateCreated = 'dateCreated';

  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'notodo_db.db');
    var ourDb = await openDatabase(path, version: 1, onCreate: _oncreate);
    return ourDb;
  }

  void _oncreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $tableName(id INTEGER PRIMARY KEY,$columnItemName TEXT, $columnDateCreated TEXT )");
    print("Table is Created");
  }

  //Insertion
  Future<int> saveItem(NoDoItem item) async {
    var dbclient = await db;
    int res = await dbclient.insert("$tableName", item.toMap());
    print(res.toString());
    return res;
  }

  //get
  Future<List> getItems() async {
    var dbclient = await db;
    var result = await dbclient
        .rawQuery("SELECT * FROM $tableName ORDER BY $columnItemName ASC");
    return result.toList();
  }

  Future<int> getCount() async {
    var dbclient = await db;
    return Sqflite.firstIntValue(
        await dbclient.rawQuery("SELECT COUNT(*) FROM $tableName"));
  }

  Future<NoDoItem> getItem(int id) async {
    var dbclient = await db;
    var result =
        await dbclient.rawQuery("SELECT * FROM $tableName WHERE id = $id");
    if (result.length == 0) return null;
    return new NoDoItem.fromMap(result.first);
  }

  Future<int> deleteItem(int id) async {
    var dbclient = await db;
    return await dbclient
        .delete(tableName, where: "$columnId = ?", whereArgs: [id]);
  }

  Future<int> updateItem(NoDoItem item) async {
    var dbclient = await db;
    return await dbclient.update("$tableName", item.toMap(),
        where: "$columnId = ?", whereArgs: [item.id]);
  }

  Future close() async {
    var dbclient = await db;
    return dbclient.close();
  }
}
