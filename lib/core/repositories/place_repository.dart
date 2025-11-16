// core/repositories/place_repository.dart
import '../database/database_helper.dart';
import '../../screens/home/data/models/place_model.dart';
import 'base_repository.dart';

// core/repositories/protocols/place_protocols.dart

// Arquivo: place_category_reader_protocol.dart
/// Protocolo para leitura de lugares por categoria
abstract class PlaceCategoryReaderProtocol {
  /// Retorna lugares de uma categoria específica
  Future<List<PlaceModel>> getByCategory(String category);
}

// Arquivo: place_location_reader_protocol.dart
/// Protocolo para leitura de lugares por localização
abstract class PlaceLocationReaderProtocol {
  /// Retorna lugares próximos a uma coordenada
  Future<List<PlaceModel>> getNearby(
    double latitude,
    double longitude,
    double radiusKm,
  );
}

// Arquivo: place_availability_reader_protocol.dart
/// Protocolo para leitura de disponibilidade de lugares
abstract class PlaceAvailabilityReaderProtocol {
  /// Retorna apenas lugares que estão abertos
  Future<List<PlaceModel>> getOpenPlaces();
}

// Arquivo: place_search_protocol.dart
/// Protocolo para busca de lugares
abstract class PlaceSearchProtocol {
  /// Busca lugares por texto (nome, descrição ou categoria)
  Future<List<PlaceModel>> search(String searchText);
}

// Arquivo: place_discount_reader_protocol.dart
/// Protocolo para leitura de lugares com desconto
abstract class PlaceDiscountReaderProtocol {
  /// Retorna lugares que oferecem desconto
  Future<List<PlaceModel>> getPlacesWithDiscount();
}

// Arquivo: place_premium_reader_protocol.dart
/// Protocolo para leitura de lugares premium
abstract class PlacePremiumReaderProtocol {
  /// Retorna lugares exclusivos para usuários premium
  Future<List<PlaceModel>> getPremiumPlaces();
}

// Arquivo: place_rating_reader_protocol.dart
/// Protocolo para leitura de lugares por avaliação
abstract class PlaceRatingReaderProtocol {
  /// Retorna os lugares mais bem avaliados
  Future<List<PlaceModel>> getTopRated({int limit = 10});
}

// Arquivo: place_rating_updater_protocol.dart
/// Protocolo para atualização de avaliações de lugares
abstract class PlaceRatingUpdaterProtocol {
  /// Atualiza a avaliação média e contagem de reviews de um lugar
  Future<int> updateRating(String placeId, double newRating, int reviewsCount);
}

// Arquivo: place_filter_protocol.dart
/// Protocolo para filtragem avançada de lugares
abstract class PlaceFilterProtocol {
  /// Retorna lugares filtrados por múltiplos critérios
  Future<List<PlaceModel>> getFiltered({
    List<String>? categories,
    String? priceRange,
    double? minRating,
    List<String>? amenities,
    bool? openNow,
  });
}

// ============================================
// IMPLEMENTAÇÃO NO REPOSITORY
// ============================================

class PlaceRepository extends BaseRepository<PlaceModel>
    implements
        PlaceCategoryReaderProtocol,
        PlaceLocationReaderProtocol,
        PlaceAvailabilityReaderProtocol,
        PlaceSearchProtocol,
        PlaceDiscountReaderProtocol,
        PlacePremiumReaderProtocol,
        PlaceRatingReaderProtocol,
        PlaceRatingUpdaterProtocol,
        PlaceFilterProtocol {
  @override
  String get tableName => 'places';

  @override
  PlaceModel fromMap(Map<String, dynamic> map) => PlaceModel.fromMap(map);

  @override
  Map<String, dynamic> toMap(PlaceModel model) => model.toMap();

  // Buscar por categoria
  @override
  Future<List<PlaceModel>> getByCategory(String category) async {
    return await getWhere('category = ?', [category]);
  }

  // Buscar por proximidade (requer cálculo de distância)
  @override
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
  @override
  Future<List<PlaceModel>> getOpenPlaces() async {
    return await getWhere('is_open = ?', [1]);
  }

  // Buscar por texto
  @override
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
  @override
  Future<List<PlaceModel>> getPlacesWithDiscount() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'discount_percentage IS NOT NULL AND discount_percentage > 0',
    );
    return maps.map((map) => PlaceModel.fromMap(map)).toList();
  }

  // Lugares premium
  @override
  Future<List<PlaceModel>> getPremiumPlaces() async {
    return await getWhere('is_premium_only = ?', [1]);
  }

  // Top avaliados
  @override
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
  @override
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
  @override
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
