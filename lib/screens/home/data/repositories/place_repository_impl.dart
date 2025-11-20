// data/repositories/place_repository_impl.dart

import 'package:vivar/models/place_model.dart';
import 'package:vivar/domain/entity/place/place_entity.dart';
import 'package:vivar/domain/interface/place/place_repository_protocol.dart';
import 'package:vivar/screens/home/data/datasource/place_datasource.dart';

/// Implementação do repositório de lugares
/// Delega operações de dados para o datasource
/// Responsável por converter entre Model (data layer) e Entity (domain layer)
class PlaceRepositoryImpl implements PlaceRepositoryProtocol {
  final PlaceDatasourceProtocol _datasource;

  PlaceRepositoryImpl({required PlaceDatasourceProtocol datasource})
    : _datasource = datasource;

  @override
  Future<List<PlaceEntity>> getAllPlaces() async {
    final models = await _datasource.getAllPlaces();
    return models.map(_modelToEntity).toList();
  }

  @override
  Future<List<PlaceEntity>> getNearbyPlaces({
    required double latitude,
    required double longitude,
    required double radiusKm,
  }) async {
    final models = await _datasource.getNearbyPlaces(
      latitude: latitude,
      longitude: longitude,
      radiusKm: radiusKm,
    );
    return models.map(_modelToEntity).toList();
  }

  @override
  Future<List<PlaceEntity>> getPlacesByCategory(String category) async {
    final models = await _datasource.getPlacesByCategory(category);
    return models.map(_modelToEntity).toList();
  }

  @override
  Future<List<PlaceEntity>> searchPlaces(String query) async {
    final models = await _datasource.searchPlaces(query);
    return models.map(_modelToEntity).toList();
  }

  @override
  Future<PlaceEntity?> getPlaceById(String id) async {
    final model = await _datasource.getPlaceById(id);
    return model != null ? _modelToEntity(model) : null;
  }

  @override
  Future<List<PlaceEntity>> getPlacesWithDiscount() async {
    final models = await _datasource.getPlacesWithDiscount();
    return models.map(_modelToEntity).toList();
  }

  @override
  Future<List<PlaceEntity>> getTopRatedPlaces({int limit = 10}) async {
    final models = await _datasource.getTopRatedPlaces(limit: limit);
    return models.map(_modelToEntity).toList();
  }

  @override
  Future<List<PlaceEntity>> getFilteredPlaces({
    List<String>? categories,
    String? priceRange,
    double? minRating,
    List<String>? amenities,
    bool? openNow,
  }) async {
    final models = await _datasource.getFilteredPlaces(
      categories: categories,
      priceRange: priceRange,
      minRating: minRating,
      amenities: amenities,
      openNow: openNow,
    );
    return models.map(_modelToEntity).toList();
  }

  /// Converte PlaceModel (data layer) para PlaceEntity (domain layer)
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
