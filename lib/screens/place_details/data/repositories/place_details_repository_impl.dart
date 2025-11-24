// data/repositories/place_details_repository_impl.dart

import 'package:vivar/domain/entity/business/business_entity.dart';
import 'package:vivar/models/business_model.dart';
import 'package:vivar/models/place_model.dart';
import 'package:vivar/models/review_model.dart';
import 'package:vivar/domain/entity/place/place_details_entity.dart';
import 'package:vivar/domain/entity/review/review_entity.dart';
import 'package:vivar/domain/interface/place/place_details_repository_protocol.dart';
import 'package:vivar/screens/place_details/data/datasource/place_details_sync_datasource.dart';

/// Implementação do repositório de detalhes de lugares
/// Delega operações de dados para o datasource de sincronização
/// Converte entre Model e Entity
class PlaceDetailsRepositoryImpl implements PlaceDetailsRepositoryProtocol {
  final PlaceDetailsSyncDatasource _syncDatasource;

  PlaceDetailsRepositoryImpl({
    required PlaceDetailsSyncDatasource syncDatasource,
  }) : _syncDatasource = syncDatasource;

  @override
  Future<BusinessEntity?> getPlaceDetails(String placeId) async {
    final model = await _syncDatasource.getPlaceById(placeId);
    return model != null ? _placeModelToEntity(model) : null;
  }

  @override
  Future<BusinessEntity?> getPlaceById(String id) async {
    final model = await _syncDatasource.getPlaceById(id);
    return model != null ? _placeModelToEntity(model) : null;
  }

  @override
  Future<List<ReviewEntity>> getPlaceReviews(String placeId) async {
    final maps = await _syncDatasource.getPlaceReviews(placeId);
    return maps.map(_reviewMapToEntity).toList();
  }

  @override
  Future<void> addReview(ReviewEntity review) async {
    final reviewModel = _reviewEntityToModel(review);
    await _syncDatasource.addReview(reviewModel);
  }

  @override
  Future<bool> checkIfUserReviewed(String userId, String placeId) {
    return _syncDatasource.checkIfUserReviewed(userId, placeId);
  }

  /// Converte PlaceModel (data layer) para PlaceDetailsEntity (domain layer)
  BusinessEntity _placeModelToEntity(BusinessModel model) {
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

  /// Converte Map de review (com JOIN) para ReviewEntity (domain layer)
  ReviewEntity _reviewMapToEntity(Map<String, dynamic> map) {
    return ReviewEntity(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      placeId: map['place_id'] as String,
      userName: map['user_name'] as String? ?? 'Usuário',
      userAvatarUrl: map['user_avatar_url'] as String?,
      rating: map['rating'] as double,
      comment: map['comment'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
      images: map['images'] != null ? List<String>.from(map['images']) : null,
    );
  }

  /// Converte ReviewEntity (domain layer) para ReviewModel (data layer)
  ReviewModel _reviewEntityToModel(ReviewEntity entity) {
    return ReviewModel(
      id: entity.id,
      userId: entity.userId,
      placeId: entity.placeId,
      rating: entity.rating,
      comment: entity.comment,
      images: entity.images,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
