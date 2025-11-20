// data/repositories/discover_repository_impl.dart

import 'package:vivar/domain/entity/discover/discover_collection_entity.dart';
import 'package:vivar/domain/interface/discover/discover_repository_protocol.dart';
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
  Future<List<PlaceEntity>> getCollectionPlaces(String collectionId) async {
    final models = await _getPlaceModelsForCollection(collectionId);
    return models.map(_modelToEntity).toList();
  }

  @override
  Future<List<PlaceEntity>> getTrendingPlaces() async {
    final models = await _datasource.getTrendingPlaces();
    return models.map(_modelToEntity).toList();
  }

  @override
  Future<List<PlaceEntity>> getNearYouPlaces() async {
    final models = await _datasource.getNearYouPlaces();
    return models.map(_modelToEntity).toList();
  }

  @override
  Future<List<PlaceEntity>> getTopRatedPlaces() async {
    final models = await _datasource.getTopRatedPlaces();
    return models.map(_modelToEntity).toList();
  }

  /// Busca os lugares de acordo com o ID da coleção
  Future<List<PlaceModel>> _getPlaceModelsForCollection(
    String collectionId,
  ) async {
    switch (collectionId) {
      case 'trending':
        return await _datasource.getTrendingPlaces();
      case 'near_you':
        return await _datasource.getNearYouPlaces();
      case 'top_rated':
        return await _datasource.getTopRatedPlaces();
      case 'new':
        return await _datasource.getNewPlaces();
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
        placesCount: 12,
      ),
      DiscoverCollectionEntity(
        id: 'near_you',
        title: 'Perto de Você',
        category: 'Proximidade',
        description: 'Descubra lugares próximos à sua localização',
        imageUrl: 'assets/images/near.jpg',
        placesCount: 8,
      ),
      DiscoverCollectionEntity(
        id: 'top_rated',
        title: 'Mais Bem Avaliados',
        category: 'Qualidade',
        description: 'Os lugares com as melhores avaliações',
        imageUrl: 'assets/images/top_rated.jpg',
        placesCount: 15,
      ),
      DiscoverCollectionEntity(
        id: 'new',
        title: 'Novos Lugares',
        category: 'Novidades',
        description: 'Lugares recém adicionados ao app',
        imageUrl: 'assets/images/new.jpg',
        placesCount: 6,
      ),
    ];
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
