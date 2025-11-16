// data/repositories/swipe_repository_impl.dart

import 'package:sqflite/sqflite.dart';
import 'package:vivar/core/database/database_helper.dart';
import 'package:vivar/screens/home/data/models/place_model.dart';
import 'package:vivar/screens/swipe/domain/entities/swipe_place_entity.dart';
import 'package:vivar/screens/swipe/domain/repositories/swipe_repository_protocol.dart';

class SwipeRepositoryImpl implements SwipeRepositoryProtocol {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final String _placeTableName = 'places';
  final String _favoriteTableName = 'favorites';

  Future<Database> get _database async => await _dbHelper.database;

  @override
  Future<List<SwipePlaceEntity>> getSwipePlaces() async {
    final db = await _database;
    final List<Map<String, dynamic>> maps = await db.query(
      _placeTableName,
      orderBy: 'RANDOM()',
      limit: 50,
    );
    return maps.map((map) => _modelToEntity(PlaceModel.fromMap(map))).toList();
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
  Future<void> dislikePlace(String userId, String placeId) async {
    // Implementar lógica de dislike se necessário
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

  SwipePlaceEntity _modelToEntity(PlaceModel model) {
    final tags = <String>[];
    if (model.amenities != null) {
      tags.addAll(model.amenities!.take(3));
    }

    double distance = 0.0;
    if (model.distance != null) {
      distance = model.distance! / 1000;
    }

    return SwipePlaceEntity(
      id: model.id,
      name: model.name,
      category: model.category,
      description: model.description ?? 'Sem descrição',
      rating: model.rating,
      priceRange: model.priceRange ?? '\$\$',
      distance: distance,
      tags: tags,
      images: model.images,
      discount: model.discountText,
      isOpen: model.isOpen,
    );
  }
}
