import 'package:sqflite/sqflite.dart';
import 'package:vivar/core/database/database_helper.dart';
import 'package:vivar/models/business_model.dart';
import 'package:vivar/models/place_model.dart';

abstract class SwipeLocalDataSourceProtocol {
  Future<List<BusinessModel>> getSwipePlaces();
  Future<void> likePlace(String userId, String placeId);
  Future<void> superLikePlace(String userId, String placeId);
  Future<void> dislikePlace(String userId, String placeId);
}

class SwipeLocalDataSource implements SwipeLocalDataSourceProtocol {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final String _placeTableName = 'businesses';
  final String _favoriteTableName = 'favorites';

  Future<Database> get _database async => await _dbHelper.database;

  @override
  Future<List<BusinessModel>> getSwipePlaces() async {
    final db = await _database;

    final maps = await db.query(
      _placeTableName,
      orderBy: "RANDOM()",
      limit: 50,
    );

    return maps.map((map) => BusinessModel.fromMap(map)).toList();
  }

  @override
  Future<void> likePlace(String userId, String placeId) async {
    final db = await _database;

    await db.insert(_favoriteTableName, {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'user_id': userId,
      'place_id': placeId,
      'created_at': DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> superLikePlace(String userId, String placeId) async {
    final db = await _database;

    await db.insert(_favoriteTableName, {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'user_id': userId,
      'place_id': placeId,
      'is_super_like': 1,
      'created_at': DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> dislikePlace(String userId, String placeId) async {
    // implementar se necessário
  }
}
