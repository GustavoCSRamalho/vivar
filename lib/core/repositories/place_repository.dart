// core/repositories/place_repository.dart
import '../database/database_helper.dart';
import '../../models/place_model.dart';
import 'base_repository.dart';

class PlaceRepository extends BaseRepository<PlaceModel> {
  @override
  String get tableName => 'places';

  @override
  PlaceModel fromMap(Map<String, dynamic> map) => PlaceModel.fromMap(map);

  @override
  Map<String, dynamic> toMap(PlaceModel model) => model.toMap();

  // Buscar por categoria
  Future<List<PlaceModel>> getByCategory(String category) async {
    return await getWhere('category = ?', [category]);
  }

  // Buscar por proximidade (requer cálculo de distância)
  Future<List<PlaceModel>> getNearby(
    double latitude,
    double longitude,
    double radiusKm,
  ) async {
    final db = await database;
    // Fórmula de Haversine simplificada para SQLite
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

    return maps.map((map) => PlaceModel.fromMap(map)).toList();
  }

  // Buscar lugares abertos
  Future<List<PlaceModel>> getOpenPlaces() async {
    return await getWhere('is_open = ?', [1]);
  }

  // Buscar por texto
  Future<List<PlaceModel>> search(String searchText) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'name LIKE ? OR description LIKE ? OR category LIKE ?',
      whereArgs: ['%$searchText%', '%$searchText%', '%$searchText%'],
    );
    return maps.map((map) => PlaceModel.fromMap(map)).toList();
  }

  // Lugares com desconto
  Future<List<PlaceModel>> getPlacesWithDiscount() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'discount_percentage IS NOT NULL AND discount_percentage > 0',
    );
    return maps.map((map) => PlaceModel.fromMap(map)).toList();
  }

  // Lugares premium
  Future<List<PlaceModel>> getPremiumPlaces() async {
    return await getWhere('is_premium_only = ?', [1]);
  }

  // Top avaliados
  Future<List<PlaceModel>> getTopRated({int limit = 10}) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      orderBy: 'rating DESC, reviews_count DESC',
      limit: limit,
    );
    return maps.map((map) => PlaceModel.fromMap(map)).toList();
  }

  // Atualizar rating
  Future<int> updateRating(
    String placeId,
    double newRating,
    int reviewsCount,
  ) async {
    final db = await database;
    return await db.update(
      tableName,
      {
        'rating': newRating,
        'reviews_count': reviewsCount,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [placeId],
    );
  }

  // Filtros avançados
  Future<List<PlaceModel>> getFiltered({
    List<String>? categories,
    String? priceRange,
    double? minRating,
    List<String>? amenities,
    bool? openNow,
  }) async {
    final db = await database;
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

    return maps.map((map) => PlaceModel.fromMap(map)).toList();
  }
}
