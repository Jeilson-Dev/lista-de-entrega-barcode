import 'dart:async';
import 'dart:io' as io;
import 'package:lista_de_entrega_barcode/models/object_delivery_dto.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DBHelper {
  static Database? _db;
  static const String id = 'id';
  static const String code = 'code';
  static const String address = 'address';
  static const String number = 'number';
  static const String table = 'objects';
  static const String dbName = 'delivery_list.db';

  Future<Database?> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, dbName);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  deleteTable() {
    if (_db != null) _db!.delete(table);
  }

  _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $table ($id INTEGER PRIMARY KEY, $code TEXT, $address TEXT, $number TEXT)");
  }

  Future<ObjectDeliveryDto> save(ObjectDeliveryDto object) async {
    var dbClient = await db;
    if (dbClient != null) object.id = await dbClient.insert(table, object.toJson());
    return object;
  }

  Future<List<ObjectDeliveryDto>> getObjects() async {
    List<ObjectDeliveryDto> objectsDelivery = [];
    var dbClient = await db;
    if (dbClient != null) {
      List<Map> result = await dbClient.query(table, columns: [id, code, address, number]);

      if (result.isNotEmpty) {
        objectsDelivery = result.map((object) => ObjectDeliveryDto.fromJson(object as Map<String, dynamic>)).toList();
      }
    }
    return objectsDelivery;
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    if (dbClient != null) return await dbClient.delete(table, where: '$id = ?', whereArgs: [id]);
    return -1;
  }

  Future<int> update(ObjectDeliveryDto employee) async {
    var dbClient = await db;
    if (dbClient != null) return await dbClient.update(table, employee.toJson(), where: '$id = ?', whereArgs: [employee.id]);
    return -1;
  }

  Future close() async {
    var dbClient = await db;
    if (dbClient != null) dbClient.close();
  }
}
