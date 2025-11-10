// core/repositories/review_repository.dart
import '../database/database_helper.dart';
import '../../models/review_model.dart';
import 'base_repository.dart';
import 'package:sqflite/sqflite.dart';

class ReviewRepository extends BaseRepository<ReviewModel> {
  @override
  String get tableName => 'reviews';

  @override
  ReviewModel fromMap(Map<String, dynamic> map) => ReviewModel.fromMap(map);

  @override
  Map<String, dynamic> toMap(ReviewModel model) => model.toMap();

  // Reviews de um lugar
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
  Future<List<ReviewModel>> getUserReviews(String userId) async {
    return await getWhere('user_id = ?', [userId]);
  }

  // Média de rating de um lugar
  Future<double> getAverageRating(String placeId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT AVG(rating) as average FROM $tableName WHERE place_id = ?',
      [placeId],
    );
    return result.first['average'] as double? ?? 0.0;
  }

  // Contagem de reviews de um lugar
  Future<int> getReviewsCount(String placeId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $tableName WHERE place_id = ?',
      [placeId],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // Verificar se usuário já avaliou
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
