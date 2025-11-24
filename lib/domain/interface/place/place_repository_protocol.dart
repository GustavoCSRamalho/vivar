// domain/repositories/place_repository_protocol.dart

import 'package:vivar/domain/entity/business/business_entity.dart';

abstract class PlaceRepositoryProtocol {
  Future<List<BusinessEntity>> getAllPlaces();

  Future<List<BusinessEntity>> getNearbyPlaces({
    required double latitude,
    required double longitude,
    required double radiusKm,
  });

  Future<List<BusinessEntity>> getPlacesByCategory(String category);

  Future<List<BusinessEntity>> searchPlaces(String query);

  Future<BusinessEntity?> getPlaceById(String id);

  Future<List<BusinessEntity>> getPlacesWithDiscount();

  Future<List<BusinessEntity>> getTopRatedPlaces({int limit = 10});

  Future<List<BusinessEntity>> getFilteredPlaces({
    List<String>? categories,
    String? priceRange,
    double? minRating,
    List<String>? amenities,
    bool? openNow,
  });
}
