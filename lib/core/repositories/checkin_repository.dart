// core/repositories/checkin_repository.dart
import '../database/database_helper.dart';
import '../../models/checkin_model.dart';
import 'base_repository.dart';
import 'package:sqflite/sqflite.dart';

class CheckinRepository extends BaseRepository<CheckinModel> {
  @override
  String get tableName => 'checkins';

  @override
  CheckinModel fromMap(Map<String, dynamic> map) => CheckinModel.fromMap(map);

  @override
  Map<String, dynamic> toMap(CheckinModel model) => model.toMap();

  // Check-ins do usuário
  Future<List<CheckinModel>> getUserCheckins(String userId) async {
    return await getWhere('user_id = ?', [userId]);
  }

  // Check-ins recentes do usuário
  Future<List<CheckinModel>> getRecentCheckins(
    String userId, {
    int limit = 10,
  }) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
      limit: limit,
    );
    return maps.map((map) => CheckinModel.fromMap(map)).toList();
  }

  // Check-ins de um lugar
  Future<List<CheckinModel>> getPlaceCheckins(String placeId) async {
    return await getWhere('place_id = ?', [placeId]);
  }

  // Verificar se usuário já fez check-in hoje em um lugar
  Future<bool> hasCheckedInToday(String userId, String placeId) async {
    final db = await database;
    final today = DateTime.now();
    final startOfDay = DateTime(
      today.year,
      today.month,
      today.day,
    ).toIso8601String();

    final result = await db.query(
      tableName,
      where: 'user_id = ? AND place_id = ? AND created_at >= ?',
      whereArgs: [userId, placeId, startOfDay],
      limit: 1,
    );

    return result.isNotEmpty;
  }

  // Total de pontos ganhos pelo usuário
  Future<int> getTotalPointsEarned(String userId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT SUM(points_earned) as total FROM $tableName WHERE user_id = ?',
      [userId],
    );
    return result.first['total'] as int? ?? 0;
  }

  // Contagem de check-ins por usuário
  Future<int> getCheckinCount(String userId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $tableName WHERE user_id = ?',
      [userId],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // Contagem de lugares únicos visitados
  Future<int> getUniquePlacesVisited(String userId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(DISTINCT place_id) as count FROM $tableName WHERE user_id = ?',
      [userId],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // Streak de dias consecutivos
  Future<int> getCurrentStreak(String userId) async {
    final db = await database;
    final checkins = await db.query(
      tableName,
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );

    if (checkins.isEmpty) return 0;

    int streak = 0;
    DateTime? lastDate;

    for (var checkin in checkins) {
      final checkinDate = DateTime.parse(checkin['created_at'] as String);
      final dateOnly = DateTime(
        checkinDate.year,
        checkinDate.month,
        checkinDate.day,
      );

      if (lastDate == null) {
        lastDate = dateOnly;
        streak = 1;
      } else {
        final difference = lastDate.difference(dateOnly).inDays;
        if (difference == 1) {
          streak++;
          lastDate = dateOnly;
        } else if (difference > 1) {
          break;
        }
      }
    }

    return streak;
  }
}
