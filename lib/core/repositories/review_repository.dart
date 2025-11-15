// core/repositories/review_repository.dart
import '../database/database_helper.dart';
import '../../models/review_model.dart';
import 'base_repository.dart';
import 'package:sqflite/sqflite.dart';

// core/repositories/protocols/review_protocols.dart

// Arquivo: place_review_reader_protocol.dart
/// Protocolo para leitura de reviews de lugares
abstract class PlaceReviewReaderProtocol {
  /// Retorna todas as reviews de um lugar específico
  Future<List<ReviewModel>> getPlaceReviews(String placeId);
}

// Arquivo: user_review_reader_protocol.dart
/// Protocolo para leitura de reviews do usuário
abstract class UserReviewReaderProtocol {
  /// Retorna todas as reviews feitas por um usuário
  Future<List<ReviewModel>> getUserReviews(String userId);
}

// Arquivo: review_statistics_protocol.dart
/// Protocolo para estatísticas de reviews
abstract class ReviewStatisticsProtocol {
  /// Retorna a média de avaliação de um lugar
  Future<double> getAverageRating(String placeId);

  /// Retorna a contagem total de reviews de um lugar
  Future<int> getReviewsCount(String placeId);
}

// Arquivo: review_validator_protocol.dart
/// Protocolo para validação de reviews
abstract class ReviewValidatorProtocol {
  /// Verifica se o usuário já avaliou um lugar específico
  Future<bool> hasUserReviewed(String userId, String placeId);
}

// ============================================
// IMPLEMENTAÇÃO NO REPOSITORY
// ============================================

class ReviewRepository extends BaseRepository<ReviewModel>
    implements
        PlaceReviewReaderProtocol,
        UserReviewReaderProtocol,
        ReviewStatisticsProtocol,
        ReviewValidatorProtocol {
  @override
  String get tableName => 'reviews';

  @override
  ReviewModel fromMap(Map<String, dynamic> map) => ReviewModel.fromMap(map);

  @override
  Map<String, dynamic> toMap(ReviewModel model) => model.toMap();

  // Reviews de um lugar
  @override
  Future<List<ReviewModel>> getPlaceReviews(String placeId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'place_id = ?',
      whereArgs: [placeId],
      orderBy: 'created_at DESC',
    );
    return maps.map((map) => ReviewModel.fromMap(map)).toList();
  }

  // Reviews do usuário
  @override
  Future<List<ReviewModel>> getUserReviews(String userId) async {
    return await getWhere('user_id = ?', [userId]);
  }

  // Média de rating de um lugar
  @override
  Future<double> getAverageRating(String placeId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT AVG(rating) as average FROM $tableName WHERE place_id = ?',
      [placeId],
    );
    return result.first['average'] as double? ?? 0.0;
  }

  // Contagem de reviews de um lugar
  @override
  Future<int> getReviewsCount(String placeId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $tableName WHERE place_id = ?',
      [placeId],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // Verificar se usuário já avaliou
  @override
  Future<bool> hasUserReviewed(String userId, String placeId) async {
    final db = await database;
    final result = await db.query(
      tableName,
      where: 'user_id = ? AND place_id = ?',
      whereArgs: [userId, placeId],
      limit: 1,
    );
    return result.isNotEmpty;
  }
}
