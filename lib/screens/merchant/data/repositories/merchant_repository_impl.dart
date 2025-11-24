// data/repositories/merchant_repository_impl.dart

import 'package:vivar/domain/entity/business/business_entity.dart';
import 'package:vivar/domain/entity/merchant/merchant_entity.dart';
import 'package:vivar/domain/interface/merchant/merchant_repository_protocol.dart';
import 'package:vivar/models/business_model.dart';
import 'package:vivar/models/merchant_model.dart';
import 'package:vivar/screens/merchant/data/datasource/merchant_sync_datasource.dart';

/// Implementação do repositório de comerciantes
/// Delega operações de dados para o datasource de sincronização
/// Responsável por converter entre Model (data layer) e Entity (domain layer)
class MerchantRepositoryImpl implements MerchantRepositoryProtocol {
  final MerchantSyncDatasource _syncDatasource;

  MerchantRepositoryImpl({required MerchantSyncDatasource syncDatasource})
    : _syncDatasource = syncDatasource;

  @override
  Future<void> registerMerchant(BusinessEntity merchant) async {
    final model = _entityToModel(merchant);
    await _syncDatasource.registerMerchant(model);
  }

  @override
  Future<BusinessEntity?> getMerchantById(String merchantId) async {
    final model = await _syncDatasource.getMerchantById(merchantId);
    return model != null ? _modelToEntity(model) : null;
  }

  @override
  Future<List<BusinessEntity>> getUserMerchants(String userId) async {
    final models = await _syncDatasource.getUserMerchants(userId);
    return models.map(_modelToEntity).toList();
  }

  Future<void> updateMerchant(BusinessEntity merchant) async {
    final model = _entityToModel(merchant);
    await _syncDatasource.updateMerchant(model);
  }

  Future<void> markAsPendingSync(String merchantId) async {
    await _syncDatasource.markAsPendingSync(merchantId);
  }

  Future<List<BusinessEntity>> getPendingMerchants() async {
    final models = await _syncDatasource.getPendingMerchants();
    return models.map(_modelToEntity).toList();
  }

  Future<void> retrySyncAll() async {
    await _syncDatasource.syncPendingMerchants();
  }

  /// Converte MerchantModel (data layer) para MerchantEntity (domain layer)
  BusinessEntity _modelToEntity(BusinessModel model) {
    return BusinessEntity(
      id: model.id,
      userId: model.userId,
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
      schedule: model.schedule,
      isWhatsapp: model.isWhatsapp,
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
      synced: model.synced,
    );
  }

  /// Converte MerchantEntity (domain layer) para MerchantModel (data layer)
  BusinessModel _entityToModel(BusinessEntity entity) {
    return BusinessModel(
      id: entity.id,
      userId: entity.userId,
      name: entity.name,
      category: entity.category,
      description: entity.description,
      address: entity.address,
      city: entity.city,
      state: entity.state,
      latitude: entity.latitude,
      longitude: entity.longitude,
      phone: entity.phone,
      whatsapp: entity.whatsapp,
      email: entity.email,
      website: entity.website,
      schedule: entity.schedule,
      isWhatsapp: entity.isWhatsapp,
      rating: entity.rating,
      reviewsCount: entity.reviewsCount,
      priceRange: entity.priceRange,
      isOpen: entity.isOpen,
      openingHours: entity.openingHours,
      amenities: entity.amenities,
      images: entity.images,
      discountText: entity.discountText,
      discountPercentage: entity.discountPercentage,
      isPremiumOnly: entity.isPremiumOnly,
      distance: entity.distance,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      synced: entity.synced,
    );
  }
}
