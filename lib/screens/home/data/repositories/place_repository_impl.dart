// data/repositories/place_repository_impl.dart

import 'package:sqflite/sqflite.dart';
import 'package:vivar/core/database/database_helper.dart';
import 'package:vivar/models/place_model.dart';
import 'package:vivar/domain/entity/place_entity.dart';
import 'package:vivar/domain/interface/place/place_repository_protocol.dart';

class PlaceRepositoryImpl implements PlaceRepositoryProtocol {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final String tableName = 'places';

  Future<Database> get _database async => await _dbHelper.database;

  @override
  Future<List<PlaceEntity>> getAllPlaces() async {
    final db = await _database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return maps.map((map) => _modelToEntity(PlaceModel.fromMap(map))).toList();
  }

  @override
  Future<List<PlaceEntity>> getNearbyPlaces({
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
  Future<List<PlaceEntity>> getPlacesByCategory(String category) async {
    final db = await _database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'category = ?',
      whereArgs: [category],
    );
    return maps.map((map) => _modelToEntity(PlaceModel.fromMap(map))).toList();
  }

  @override
  Future<List<PlaceEntity>> searchPlaces(String query) async {
    final db = await _database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'name LIKE ? OR description LIKE ? OR category LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
    );
    return maps.map((map) => _modelToEntity(PlaceModel.fromMap(map))).toList();
  }

  @override
  Future<PlaceEntity?> getPlaceById(String id) async {
    final db = await _database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return _modelToEntity(PlaceModel.fromMap(maps.first));
  }

  @override
  Future<List<PlaceEntity>> getPlacesWithDiscount() async {
    final db = await _database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'discount_percentage IS NOT NULL AND discount_percentage > 0',
    );
    return maps.map((map) => _modelToEntity(PlaceModel.fromMap(map))).toList();
  }

  @override
  Future<List<PlaceEntity>> getTopRatedPlaces({int limit = 10}) async {
    final db = await _database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      orderBy: 'rating DESC, reviews_count DESC',
      limit: limit,
    );
    return maps.map((map) => _modelToEntity(PlaceModel.fromMap(map))).toList();
  }

  @override
  Future<List<PlaceEntity>> getFilteredPlaces({
    List<String>? categories,
    String? priceRange,
    double? minRating,
    List<String>? amenities,
    bool? openNow,
  }) async {
    final db = await _database;
    String where = '1=1';
    List<dynamic> whereArgs = [];

    if (categories != null && categories.isNotEmpty) {
      where += ' AND category IN (${categories.map((_) => '?').join(',')})';
      whereArgs.addAll(categories);
    }

    if (priceRange != null) {
      where += ' AND price_range = ?';
      whereArgs.add(priceRange);
    }

    if (minRating != null) {
      where += ' AND rating >= ?';
      whereArgs.add(minRating);
    }

    if (openNow != null && openNow) {
      where += ' AND is_open = 1';
    }

    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: where,
      whereArgs: whereArgs,
    );

    return maps.map((map) => _modelToEntity(PlaceModel.fromMap(map))).toList();
  }

  PlaceEntity _modelToEntity(PlaceModel model) {
    return PlaceEntity(
      id: model.id,
      name: model.name,
      category: model.category,
      description: model.description,
      address: model.address,
      city: model.city,
      state: model.state,
      latitude: model.latitude,
      longitude: model.longitude,
      phone: model.phone,
      whatsapp: model.whatsapp,
      email: model.email,
      website: model.website,
      rating: model.rating,
      reviewsCount: model.reviewsCount,
      priceRange: model.priceRange,
      isOpen: model.isOpen,
      openingHours: model.openingHours,
      amenities: model.amenities,
      images: model.images,
      discountText: model.discountText,
      discountPercentage: model.discountPercentage,
      isPremiumOnly: model.isPremiumOnly,
      distance: model.distance,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }
}
