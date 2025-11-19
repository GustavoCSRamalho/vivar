// data/repositories/map_repository_impl.dart

import 'package:sqflite/sqflite.dart';
import 'package:vivar/core/database/database_helper.dart';
import 'package:vivar/screens/home/data/models/place_model.dart';
import 'package:vivar/screens/map/domain/entities/map_place_entity.dart';
import 'package:vivar/screens/map/domain/repositories/map_repository_protocol.dart';

class MapRepositoryImpl implements MapRepositoryProtocol {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final String tableName = 'places';

  Future<Database> get _database async => await _dbHelper.database;

  @override
  Future<List<MapPlaceEntity>> getPlacesForMap() async {
    final db = await _database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return maps.map((map) => _modelToEntity(PlaceModel.fromMap(map))).toList();
  }

  @override
  Future<List<MapPlaceEntity>> getPlacesByCategory(String category) async {
    final db = await _database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'category = ?',
      whereArgs: [category],
    );
    return maps.map((map) => _modelToEntity(PlaceModel.fromMap(map))).toList();
  }

  @override
  Future<List<MapPlaceEntity>> getNearbyPlacesForMap({
    required double latitude,
    required double longitude,
    required double radiusKm,
  }) async {
    final db = await _database;
    final query =
        '''
      SELECT *
      FROM (
        SELECT *,
          (6371 * acos(
            cos(radians(?)) * cos(radians(latitude)) *
            cos(radians(longitude) - radians(?)) +
            sin(radians(?)) * sin(radians(latitude))
          )) AS distance
        FROM $tableName
      )
      WHERE distance < ?
      ORDER BY distance
    ''';

    final List<Map<String, dynamic>> maps = await db.rawQuery(query, [
      latitude,
      longitude,
      latitude,
      radiusKm,
    ]);

    return maps.map((map) => _modelToEntity(PlaceModel.fromMap(map))).toList();
  }

  @override
  Future<List<MapPlaceEntity>> searchPlacesOnMap(String query) async {
    final db = await _database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'name LIKE ? OR description LIKE ? OR category LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
    );
    return maps.map((map) => _modelToEntity(PlaceModel.fromMap(map))).toList();
  }

  MapPlaceEntity _modelToEntity(PlaceModel model) {
    String? formattedDistance;
    if (model.distance != null) {
      if (model.distance! < 1000) {
        formattedDistance = '${model.distance!.toStringAsFixed(0)}m';
      } else {
        formattedDistance = '${(model.distance! / 1000).toStringAsFixed(1)}km';
      }
    }

    return MapPlaceEntity(
      id: model.id,
      name: model.name,
      description: model.description,
      category: model.category,
      latitude: model.latitude,
      longitude: model.longitude,
      rating: model.rating,
      distance: formattedDistance,
      discount: model.discountText,
      isOpen: model.isOpen,
      imageUrl: model.images?.isNotEmpty == true ? model.images!.first : null,
    );
  }
}
