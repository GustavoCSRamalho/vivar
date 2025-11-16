// data/repositories/user_repository_impl.dart

import 'package:sqflite/sqflite.dart';
import 'package:vivar/core/database/database_helper.dart';
import 'package:vivar/screens/home/data/models/user_model.dart';
import 'package:vivar/screens/home/domain/entities/user_entity.dart';
import 'package:vivar/screens/home/domain/repositories/user_repository_protocol.dart';

class UserRepositoryImpl implements UserRepositoryProtocol {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final String _userTableName = 'users';
  final String _favoriteTableName = 'favorites';

  Future<Database> get _database async => await _dbHelper.database;

  @override
  Future<UserEntity?> getCurrentUser() async {
    final db = await _database;
    final List<Map<String, dynamic>> maps = await db.query(
      _userTableName,
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return _modelToEntity(UserModel.fromMap(maps.first));
  }

  @override
  Future<UserEntity?> getUserById(String id) async {
    final db = await _database;
    final List<Map<String, dynamic>> maps = await db.query(
      _userTableName,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return _modelToEntity(UserModel.fromMap(maps.first));
  }

  @override
  Future<void> updateUser(UserEntity user) async {
    final db = await _database;
    final model = _entityToModel(user);
    await db.update(
      _userTableName,
      model.toMap(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }

  @override
  Future<List<String>> getUserFavoritePlaceIds(String userId) async {
    final db = await _database;
    final List<Map<String, dynamic>> maps = await db.query(
      _favoriteTableName,
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    return maps.map((m) => m['place_id'] as String).toList();
  }

  @override
  Future<void> addFavorite(String userId, String placeId) async {
    final db = await _database;
    await db.insert(_favoriteTableName, {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'user_id': userId,
      'place_id': placeId,
      'created_at': DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> removeFavorite(String userId, String placeId) async {
    final db = await _database;
    await db.delete(
      _favoriteTableName,
      where: 'user_id = ? AND place_id = ?',
      whereArgs: [userId, placeId],
    );
  }

  @override
  Future<bool> toggleFavorite(String userId, String placeId) async {
    final db = await _database;

    final existing = await db.query(
      _favoriteTableName,
      where: 'user_id = ? AND place_id = ?',
      whereArgs: [userId, placeId],
    );

    if (existing.isNotEmpty) {
      await db.delete(
        _favoriteTableName,
        where: 'user_id = ? AND place_id = ?',
        whereArgs: [userId, placeId],
      );
      return false;
    } else {
      await db.insert(_favoriteTableName, {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'user_id': userId,
        'place_id': placeId,
        'created_at': DateTime.now().toIso8601String(),
      });
      return true;
    }
  }

  UserEntity _modelToEntity(UserModel model) {
    return UserEntity(
      id: model.id,
      email: model.email,
      name: model.name,
      username: model.username,
      avatarUrl: model.avatarUrl,
      bio: model.bio,
      phone: model.phone,
      location: model.location,
      planType: model.planType,
      points: model.points,
      placesVisited: model.placesVisited,
      badgesCount: model.badgesCount,
      streakDays: model.streakDays,
      favoriteCount: model.favoriteCount,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }

  UserModel _entityToModel(UserEntity entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      name: entity.name,
      username: entity.username,
      avatarUrl: entity.avatarUrl,
      bio: entity.bio,
      phone: entity.phone,
      location: entity.location,
      planType: entity.planType,
      points: entity.points,
      placesVisited: entity.placesVisited,
      badgesCount: entity.badgesCount,
      streakDays: entity.streakDays,
      favoriteCount: entity.favoriteCount,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
