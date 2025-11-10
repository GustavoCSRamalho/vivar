// core/repositories/base_repository.dart
import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';

abstract class BaseRepository<T> {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  String get tableName;

  T fromMap(Map<String, dynamic> map);
  Map<String, dynamic> toMap(T model);

  Future<Database> get database async => await _dbHelper.database;

  // CRUD básico
  Future<String> insert(T model) async {
    final db = await database;
    final map = toMap(model);
    await db.insert(
      tableName,
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return map['id'];
  }

  Future<List<T>> getAll() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return maps.map((map) => fromMap(map)).toList();
  }

  Future<T?> getById(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return fromMap(maps.first);
  }

  Future<int> update(T model) async {
    final db = await database;
    final map = toMap(model);
    return await db.update(
      tableName,
      map,
      where: 'id = ?',
      whereArgs: [map['id']],
    );
  }

  Future<int> delete(String id) async {
    final db = await database;
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteAll() async {
    final db = await database;
    return await db.delete(tableName);
  }

  // Métodos auxiliares
  Future<int> count() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $tableName',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<List<T>> getWhere(String where, List<dynamic> whereArgs) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: where,
      whereArgs: whereArgs,
    );
    return maps.map((map) => fromMap(map)).toList();
  }

  Future<bool> exists(String id) async {
    final result = await getById(id);
    return result != null;
  }

  // Métodos para sincronização
  Future<List<T>> getUnsyncedItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'synced = ?',
      whereArgs: [0],
    );
    return maps.map((map) => fromMap(map)).toList();
  }

  Future<int> markAsSynced(String id) async {
    final db = await database;
    return await db.update(
      tableName,
      {'synced': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> markAllAsSynced() async {
    final db = await database;
    await db.update(tableName, {'synced': 1});
  }
}
