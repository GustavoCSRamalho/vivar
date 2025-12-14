// data/datasources/user/user_local_datasource_protocol.dart

import 'package:core_module/core_module.dart';
import 'package:profile_module/src/data/models/user_model.dart';
import 'package:sqflite/sqflite.dart';

abstract class UserLocalDataSourceProtocol {
  Future<UserModel?> getUser(String userId);
  Future<void> updateUser(Map<String, dynamic> data, String userId);
  Future<void> updateAvatar(String userId, String url);
  Future<void> removeAvatar(String userId);
}
// data/datasources/user/user_local_datasource_impl.dart

class UserLocalDataSourceImpl implements UserLocalDataSourceProtocol {
  final DatabaseHelper _dbHelper;
  final String _userTableName = 'users';

  UserLocalDataSourceImpl({DatabaseHelper? dbHelper})
    : _dbHelper = dbHelper ?? DatabaseHelper();

  Future<Database> get _database async => await _dbHelper.database;

  @override
  Future<UserModel?> getUser(String userId) async {
    final db = await _database;

    final maps = await db.query(
      _userTableName,
      where: 'id = ?',
      whereArgs: [userId],
      limit: 1,
    );

    if (maps.isEmpty) return null;

    return UserModel.fromMap(maps.first);
  }

  @override
  Future<void> updateUser(Map<String, dynamic> data, String userId) async {
    final db = await _database;

    await db.update(_userTableName, data, where: 'id = ?', whereArgs: [userId]);
  }

  @override
  Future<void> updateAvatar(String userId, String url) async {
    final db = await _database;

    await db.update(
      _userTableName,
      {'avatar_url': url, 'updated_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  @override
  Future<void> removeAvatar(String userId) async {
    final db = await _database;

    await db.update(
      _userTableName,
      {'avatar_url': null, 'updated_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }
}
