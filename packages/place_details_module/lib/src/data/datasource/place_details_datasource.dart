// data/datasources/place/place_details_datasource.dart

import 'package:core_module/core_module.dart';
import 'package:place_details_module/src/data/models/business_model.dart';
import 'package:place_details_module/src/data/models/review_model.dart';
import 'package:sqflite/sqflite.dart';

/// Contrato abstrato para datasource de detalhes de lugares
abstract class PlaceDetailsDatasourceProtocol {
  /// Busca detalhes de um lugar por ID
  Future<BusinessModel?> getPlaceById(String placeId);

  /// Busca reviews de um lugar com dados do usuário
  Future<List<Map<String, dynamic>>> getPlaceReviews(String placeId);

  /// Adiciona uma review
  Future<void> addReview(ReviewModel review);

  /// Verifica se usuário já fez review do lugar
  Future<bool> checkIfUserReviewed(String userId, String placeId);
}

/// Implementação do datasource de detalhes de lugares
/// Contém TODA a lógica de queries de detalhes e reviews
class PlaceDetailsDatasource implements PlaceDetailsDatasourceProtocol {
  final DatabaseHelper _dbHelper;

  static const String _placeTableName = 'businesses';
  static const String _reviewTableName = 'reviews';
  static const String _userTableName = 'users';

  PlaceDetailsDatasource({DatabaseHelper? dbHelper})
    : _dbHelper = dbHelper ?? DatabaseHelper();

  Future<Database> get _database async => await _dbHelper.database;

  @override
  Future<BusinessModel?> getPlaceById(String placeId) async {
    try {
      final db = await _database;
      final List<Map<String, dynamic>> maps = await db.query(
        _placeTableName,
        where: 'id = ?',
        whereArgs: [placeId],
        limit: 1,
      );

      if (maps.isEmpty) return null;

      return BusinessModel.fromMap(maps.first);
    } catch (e) {
      print('❌ Erro ao buscar detalhes do lugar: $e');
      return null;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getPlaceReviews(String placeId) async {
    try {
      final db = await _database;
      final query = _buildReviewsQuery();

      final List<Map<String, dynamic>> maps = await db.rawQuery(query, [
        placeId,
      ]);

      return maps;
    } catch (e) {
      print('❌ Erro ao buscar reviews do lugar: $e');
      return [];
    }
  }

  @override
  Future<void> addReview(ReviewModel review) async {
    try {
      final db = await _database;
      await db.insert(
        _reviewTableName,
        review.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('❌ Erro ao adicionar review: $e');
      rethrow;
    }
  }

  @override
  Future<bool> checkIfUserReviewed(String userId, String placeId) async {
    try {
      final db = await _database;
      final result = await db.query(
        _reviewTableName,
        where: 'user_id = ? AND place_id = ?',
        whereArgs: [userId, placeId],
        limit: 1,
      );

      return result.isNotEmpty;
    } catch (e) {
      print('❌ Erro ao verificar se usuário fez review: $e');
      return false;
    }
  }

  /// Constrói query para buscar reviews com dados do usuário (JOIN)
  String _buildReviewsQuery() {
    return '''
      SELECT r.*, u.name as user_name, u.avatar_url as user_avatar_url
      FROM $_reviewTableName r
      LEFT JOIN $_userTableName u ON r.user_id = u.id
      WHERE r.place_id = ?
      ORDER BY r.created_at DESC
    ''';
  }
}
