// domain/repositories/place_repository_protocol.dart

import '../../entity/place_entity.dart';

abstract class PlaceRepositoryProtocol {
  Future<List<PlaceEntity>> getAllPlaces();

  Future<List<PlaceEntity>> getNearbyPlaces({
    required double latitude,
    required double longitude,
    required double radiusKm,
  });

  Future<List<PlaceEntity>> getPlacesByCategory(String category);

  Future<List<PlaceEntity>> searchPlaces(String query);

  Future<PlaceEntity?> getPlaceById(String id);

  Future<List<PlaceEntity>> getPlacesWithDiscount();

  Future<List<PlaceEntity>> getTopRatedPlaces({int limit = 10});

  Future<List<PlaceEntity>> getFilteredPlaces({
    List<String>? categories,
    String? priceRange,
    double? minRating,
    List<String>? amenities,
    bool? openNow,
  });
}
