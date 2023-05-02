// ignore_for_file: non_constant_identifier_names
//dbhelper ini dibuat untuk
//membuat database, membuat tabel, proses insert, read, update dan delete

import 'package:miracle/model/jamaah.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Dbhelper {
  static final Dbhelper _instance = Dbhelper._internal();
  static Database? _database;

  final String tableName = 'tableJamaah';
  final String columnId = 'id';
  final String columnName = 'nama';
  final String columnAlamat = 'alamat';
  final String columnKelamin = 'kelamin';
  final String columntglLahir = 'tglLahir';
  final String columnKontak = 'kontak';

  Dbhelper._internal();
  factory Dbhelper() => _instance;

  Future<Database?> get _db async {
    if (_database != null) {
      return _database;
    }
    _database = await _initDb();
    return _database;
  }
  Future<Database?> _initDb() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'jamaah.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    var sql = "CREATE TABLE $tableName($columnId INTEGER PRIMARY KEY, "
        "$columnName TEXT,"
        "$columnAlamat TEXT,"
        "$columnKelamin TEXT,"
        "$columntglLahir TEXT,"
        "$columnKontak TEXT)";
    await db.execute(sql);
  }
//insert ke database
  Future<int?> saveJamaah(Jamaah jamaah) async {
    var dbClient = await _db;
    return await dbClient!.insert(tableName, jamaah.toMap());
  }
//read database
  Future<List?> getAllJamaah() async {
    var dbClient = await _db;
    var result = await dbClient!.query(tableName, columns: [
      columnId,
      columnName,
      columnAlamat,
      columnKelamin,
      columntglLahir,
      columnKontak
    ]);
    return result.toList();
  }
//update database
  Future<int?> updateJamaah(Jamaah jamaah) async {
    var dbClient = await _db;
    return await dbClient!.update(tableName, jamaah.toMap(), where: '$columnId = ?', whereArgs:
    [jamaah.id]);
  }
//hapus database
  Future<int?> deleteJamaah(int id) async {
    var dbClient = await _db;
    return await dbClient!.delete(tableName, where: '$columnId = ?', whereArgs: [id]);
  }
}