// core/repositories/badge_repository.dart
import '../database/database_helper.dart';
import '../../models/badge_model.dart';
import 'base_repository.dart';
import 'package:sqflite/sqflite.dart';

class BadgeRepository extends BaseRepository<BadgeModel> {
  @override
  String get tableName => 'badges';

  @override
  BadgeModel fromMap(Map<String, dynamic> map) => BadgeModel.fromMap(map);

  @override
  Map<String, dynamic> toMap(BadgeModel model) => model.toMap();

  // Badges do usuário
  Future<List<BadgeModel>> getUserBadges(String userId) async {
    return await getWhere('user_id = ?', [userId]);
  }

  // Badges recentes
  Future<List<BadgeModel>> getRecentBadges(
    String userId, {
    int limit = 5,
  }) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'earned_at DESC',
      limit: limit,
    );
    return maps.map((map) => BadgeModel.fromMap(map)).toList();
  }

  // Verificar se usuário tem badge
  Future<bool> hasBadge(String userId, String badgeType) async {
    final db = await database;
    final result = await db.query(
      tableName,
      where: 'user_id = ? AND badge_type = ?',
      whereArgs: [userId, badgeType],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  // Contagem de badges
  Future<int> getBadgesCount(String userId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $tableName WHERE user_id = ?',
      [userId],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }
}
