import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'employee.dart';

class DBHelper {
  static Database? _db;
  static const String ID = 'id';
  static const String NAME = 'name';
  static const String NAMELOG = 'nameLog';
  static const String NAMENUM = 'nameNum';
  static const String TABLE = 'Employee';
  static const String DB_NAME = 'loec.db';

  Future<Database?> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  deleteTable() {
    if (_db != null) _db!.delete(TABLE);
  }

  _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY, $NAME TEXT, $NAMELOG TEXT, $NAMENUM TEXT)");
  }

  Future<Employee> save(Employee employee) async {
    var dbClient = await db;
    if (dbClient != null) employee.id = await dbClient.insert(TABLE, employee.toJson());
    return employee;
  }

  Future<List<Employee>> getEmployees() async {
    List<Employee> employees = [];
    var dbClient = await db;
    if (dbClient != null) {
      List<Map> maps = await dbClient.query(TABLE, columns: [ID, NAME, NAMELOG, NAMENUM]);

      if (maps.isNotEmpty) {
        for (int i = 0; i < maps.length; i++) {
          if (maps[i] is Map<String, dynamic>) employees.add(Employee.fromJson(maps[i] as Map<String, dynamic>));
        }
      }
    }
    return employees;
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    if (dbClient != null) return await dbClient.delete(TABLE, where: '$ID = ?', whereArgs: [id]);
    return -1;
  }

  Future<int> update(Employee employee) async {
    var dbClient = await db;
    if (dbClient != null) return await dbClient.update(TABLE, employee.toJson(), where: '$ID = ?', whereArgs: [employee.id]);
    return -1;
  }

  Future close() async {
    var dbClient = await db;
    if (dbClient != null) dbClient.close();
  }
}
