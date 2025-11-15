// core/repositories/protocols/badge_protocols.dart

// Arquivo: user_badge_reader_protocol.dart
import 'package:vivar/core/repositories/base_repository.dart';
import 'package:vivar/models/badge_model.dart';
import 'package:sqflite/sqflite.dart';

/// Protocolo para leitura de badges do usuário
abstract class UserBadgeReaderProtocol {
  /// Retorna todos os badges de um usuário
  Future<List<BadgeModel>> getUserBadges(String userId);

  /// Retorna os badges mais recentes de um usuário
  Future<List<BadgeModel>> getRecentBadges(String userId, {int limit = 5});
}

// Arquivo: badge_validator_protocol.dart
/// Protocolo para validação de badges
abstract class BadgeValidatorProtocol {
  /// Verifica se o usuário possui um badge específico
  Future<bool> hasBadge(String userId, String badgeType);
}

// Arquivo: badge_counter_protocol.dart
/// Protocolo para contagem de badges
abstract class BadgeCounterProtocol {
  /// Retorna a quantidade total de badges de um usuário
  Future<int> getBadgesCount(String userId);
}

// ============================================
// IMPLEMENTAÇÃO NO REPOSITORY
// ============================================

class BadgeRepository extends BaseRepository<BadgeModel>
    implements
        UserBadgeReaderProtocol,
        BadgeValidatorProtocol,
        BadgeCounterProtocol {
  @override
  String get tableName => 'badges';

  @override
  BadgeModel fromMap(Map<String, dynamic> map) => BadgeModel.fromMap(map);

  @override
  Map<String, dynamic> toMap(BadgeModel model) => model.toMap();

  // Badges do usuário
  @override
  Future<List<BadgeModel>> getUserBadges(String userId) async {
    return await getWhere('user_id = ?', [userId]);
  }

  // Badges recentes
  @override
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
  @override
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
  @override
  Future<int> getBadgesCount(String userId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $tableName WHERE user_id = ?',
      [userId],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }
}
