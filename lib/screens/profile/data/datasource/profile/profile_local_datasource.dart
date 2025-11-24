import 'package:sqflite/sqflite.dart';
import 'package:vivar/core/database/database_helper.dart';
import 'package:vivar/domain/entity/profile/profile_entity.dart';
import 'package:vivar/models/user_model.dart';

abstract class ProfileLocalDatasourceProtocol {
  Future<ProfileEntity?> getProfile(String userId);
  Future<void> updateProfile(ProfileEntity profile);
  Future<int> getRecentCheckinsCount(String userId);
  Future<List<String>> getRecentBadges(String userId, {int limit = 5});
}

class ProfileLocalDataSource implements ProfileLocalDatasourceProtocol {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final String _userTableName = 'users';
  final String _checkinTableName = 'checkins';
  final String _badgeTableName = 'badges';

  Future<Database> get _database async => await _dbHelper.database;

  @override
  Future<ProfileEntity?> getProfile(String userId) async {
    final db = await _database;
    final List<Map<String, dynamic>> maps = await db.query(
      _userTableName,
      where: 'id = ?',
      whereArgs: [userId],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return _modelToEntity(UserModel.fromMap(maps.first));
  }

  @override
  Future<void> updateProfile(ProfileEntity profile) async {
    final db = await _database;
    final model = _entityToModel(profile);
    await db.update(
      _userTableName,
      model.toMap(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }

  @override
  Future<int> getRecentCheckinsCount(String userId) async {
    final db = await _database;
    final thirtyDaysAgo = DateTime.now()
        .subtract(Duration(days: 30))
        .toIso8601String();
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $_checkinTableName WHERE user_id = ? AND created_at >= ?',
      [userId, thirtyDaysAgo],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  @override
  Future<List<String>> getRecentBadges(String userId, {int limit = 5}) async {
    final db = await _database;
    final List<Map<String, dynamic>> maps = await db.query(
      _badgeTableName,
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'earned_at DESC',
      limit: limit,
    );
    return maps.map((m) => m['badge_type'] as String).toList();
  }

  ProfileEntity _modelToEntity(UserModel model) {
    return ProfileEntity(
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
      businessesVisited: model.businessesVisited,
      badgesCount: model.badgesCount,
      streakDays: model.streakDays,
      favoriteCount: model.favoriteCount,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }

  UserModel _entityToModel(ProfileEntity entity) {
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
      businessesVisited: entity.businessesVisited,
      badgesCount: entity.badgesCount,
      streakDays: entity.streakDays,
      favoriteCount: entity.favoriteCount,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
