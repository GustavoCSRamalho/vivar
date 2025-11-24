// data/repositories/discover_repository_impl.dart

import 'package:vivar/domain/entity/business/business_entity.dart';
import 'package:vivar/domain/entity/discover/discover_collection_entity.dart';
import 'package:vivar/domain/interface/discover/discover_repository_protocol.dart';
import 'package:vivar/models/business_model.dart';
import 'package:vivar/models/place_model.dart';
import 'package:vivar/domain/entity/place/place_entity.dart';
import 'package:vivar/screens/discover/data/datasource/discover_datasource.dart';

/// Implementação do repositório de descoberta
/// Delega operações de busca de lugares para o datasource
/// Gerencia as coleções de descoberta e converte Model para Entity
class DiscoverRepositoryImpl implements DiscoverRepositoryProtocol {
  final DiscoverDatasourceProtocol _datasource;

  DiscoverRepositoryImpl({required DiscoverDatasourceProtocol datasource})
    : _datasource = datasource;

  @override
  Future<List<DiscoverCollectionEntity>> getCollections() async {
    // Retorna as coleções disponíveis
    // Em uma implementação futura, isso poderia vir de uma API ou banco
    return _buildCollections();
  }

  @override
  Future<List<BusinessEntity>> getCollectionBusinesses(
    String collectionId,
  ) async {
    final models = await _getPlaceModelsForCollection(collectionId);
    return models;
  }

  @override
  Future<List<BusinessEntity>> getTrendingBusinesses() async {
    final models = await _datasource.getTrendingBusinesses();
    return models.map(_modelToEntity).toList();
  }

  @override
  Future<List<BusinessEntity>> getNearYouBusinesses() async {
    final models = await _datasource.getNearYouBusinesses();
    return models.map(_modelToEntity).toList();
  }

  @override
  Future<List<BusinessEntity>> getTopRatedBusinesses() async {
    final models = await _datasource.getTopRatedBusinesses();
    return models.map(_modelToEntity).toList();
  }

  /// Busca os lugares de acordo com o ID da coleção
  Future<List<BusinessEntity>> _getPlaceModelsForCollection(
    String collectionId,
  ) async {
    switch (collectionId) {
      case 'trending':
        return toEntityList(await _datasource.getTrendingBusinesses());
      case 'near_you':
        return toEntityList(await _datasource.getNearYouBusinesses());
      case 'top_rated':
        return toEntityList(await _datasource.getTopRatedBusinesses());
      case 'new':
        return toEntityList(await _datasource.getNewBusinesses());
      default:
        return [];
    }
  }

  /// Constrói a lista de coleções disponíveis
  /// Em uma implementação futura, isso poderia ser configurável ou vir de uma API
  List<DiscoverCollectionEntity> _buildCollections() {
    return [
      DiscoverCollectionEntity(
        id: 'trending',
        title: 'Em Alta',
        category: 'Tendências',
        description: 'Os lugares mais populares da semana',
        imageUrl: 'assets/images/trending.jpg',
        businessesCount: 12,
      ),
      DiscoverCollectionEntity(
        id: 'near_you',
        title: 'Perto de Você',
        category: 'Proximidade',
        description: 'Descubra lugares próximos à sua localização',
        imageUrl: 'assets/images/near.jpg',
        businessesCount: 8,
      ),
      DiscoverCollectionEntity(
        id: 'top_rated',
        title: 'Mais Bem Avaliados',
        category: 'Qualidade',
        description: 'Os lugares com as melhores avaliações',
        imageUrl: 'assets/images/top_rated.jpg',
        businessesCount: 15,
      ),
      DiscoverCollectionEntity(
        id: 'new',
        title: 'Novos Lugares',
        category: 'Novidades',
        description: 'Lugares recém adicionados ao app',
        imageUrl: 'assets/images/new.jpg',
        businessesCount: 6,
      ),
    ];
  }

  /// Converte PlaceModel (data layer) para PlaceEntity (domain layer)
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

  BusinessEntity toEntity(BusinessModel model) {
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

  BusinessModel toModel(BusinessEntity entity) {
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

  List<BusinessEntity> toEntityList(List<BusinessModel> models) {
    return models.map((model) => toEntity(model)).toList();
  }

  List<BusinessModel> toModelList(List<BusinessEntity> entities) {
    return entities.map((entity) => toModel(entity)).toList();
  }
}
