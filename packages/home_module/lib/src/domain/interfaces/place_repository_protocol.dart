// domain/repositories/Businesses_repository_protocol.dart

import '../entity/business_entity.dart';

abstract class BusinessesRepositoryProtocol {
  Future<List<BusinessEntity>> getAllBusinesses();

  Future<List<BusinessEntity>> getNearbyBusinesses({
    required double latitude,
    required double longitude,
    required double radiusKm,
  });

  Future<List<BusinessEntity>> getBusinessesByCategory(String category);

  Future<List<BusinessEntity>> searchBusinesses(String query);

  Future<BusinessEntity?> getBusinessesById(String id);

  Future<List<BusinessEntity>> getBusinessesWithDiscount();

  Future<List<BusinessEntity>> getTopRatedBusinesses({int limit = 10});

  Future<List<BusinessEntity>> getFilteredBusinesses({
    List<String>? categories,
    String? priceRange,
    double? minRating,
    List<String>? amenities,
    bool? openNow,
  });
}
