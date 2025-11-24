// data/repositories/place_repository_impl.dart

import 'package:flutter/foundation.dart';
import 'package:vivar/domain/entity/business/business_entity.dart';
import 'package:vivar/models/business_model.dart';
import 'package:vivar/domain/interface/place/place_repository_protocol.dart';
import 'package:vivar/screens/home/data/datasource/place/home_place_sync_datasource.dart';

/// Implementação do repositório de lugares
/// Delega operações de dados para o sync datasource
/// Responsável por converter entre Model (data layer) e Entity (domain layer)
class PlaceRepositoryImpl implements PlaceRepositoryProtocol {
  final PlaceSyncDatasource _syncDatasource;

  PlaceRepositoryImpl({required PlaceSyncDatasource syncDatasource})
    : _syncDatasource = syncDatasource;

  @override
  Future<List<BusinessEntity>> getAllPlaces() async {
    final models = await _syncDatasource.getAllPlaces();
    debugPrint('🌍 todos os lugares... ${models.length} encontrados');
    return models.map(_modelToEntity).toList();
  }

  @override
  Future<List<BusinessEntity>> getNearbyPlaces({
    required double latitude,
    required double longitude,
    required double radiusKm,
  }) async {
    final models = await _syncDatasource.getNearbyPlaces(
      latitude: latitude,
      longitude: longitude,
      radiusKm: radiusKm,
    );
    return models.map(_modelToEntity).toList();
  }

  @override
  Future<List<BusinessEntity>> getPlacesByCategory(String category) async {
    final models = await _syncDatasource.getPlacesByCategory(category);
    return models.map(_modelToEntity).toList();
  }

  @override
  Future<List<BusinessEntity>> searchPlaces(String query) async {
    final models = await _syncDatasource.searchPlaces(query);
    return models.map(_modelToEntity).toList();
  }

  @override
  Future<BusinessEntity?> getPlaceById(String id) async {
    final model = await _syncDatasource.getPlaceById(id);
    return model != null ? _modelToEntity(model) : null;
  }

  @override
  Future<List<BusinessEntity>> getPlacesWithDiscount() async {
    final models = await _syncDatasource.getPlacesWithDiscount();
    return models.map(_modelToEntity).toList();
  }

  @override
  Future<List<BusinessEntity>> getTopRatedPlaces({int limit = 10}) async {
    final models = await _syncDatasource.getTopRatedPlaces(limit: limit);
    return models.map(_modelToEntity).toList();
  }

  @override
  Future<List<BusinessEntity>> getFilteredPlaces({
    List<String>? categories,
    String? priceRange,
    double? minRating,
    List<String>? amenities,
    bool? openNow,
  }) async {
    final models = await _syncDatasource.getFilteredPlaces(
      categories: categories,
      priceRange: priceRange,
      minRating: minRating,
      amenities: amenities,
      openNow: openNow,
    );
    return models.map(_modelToEntity).toList();
  }

  /// Converte BusinessModel (data layer) para BusinessEntity (domain layer)
  BusinessEntity _modelToEntity(BusinessModel model) {
    return BusinessEntity(
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
