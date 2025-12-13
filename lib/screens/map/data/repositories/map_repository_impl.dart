// data/repositories/map_repository_impl.dart

import '../../../../../packages/home_module/lib/src/data/models/business_model.dart';
import 'package:vivar/models/place_model.dart';
import 'package:vivar/domain/entity/map/map_place_entity.dart';
import 'package:vivar/domain/interface/map/map_repository_protocol.dart';
import 'package:vivar/screens/map/data/datasource/map_sync_datasource.dart';

/// Implementação do repositório de mapa
/// Delega operações de dados para o datasource de sincronização
/// Converte PlaceModel para MapPlaceEntity (entidade específica do mapa)
class MapRepositoryImpl implements MapRepositoryProtocol {
  final MapSyncDatasource _syncDatasource;

  MapRepositoryImpl({required MapSyncDatasource syncDatasource})
    : _syncDatasource = syncDatasource;

  @override
  Future<List<MapPlaceEntity>> getBusinessesForMap() async {
    final models = await _syncDatasource.getBusinessesForMap();
    return models.map(_modelToEntity).toList();
  }

  @override
  Future<List<MapPlaceEntity>> getBusinessesByCategory(String category) async {
    final models = await _syncDatasource.getBusinessesByCategory(category);
    return models.map(_modelToEntity).toList();
  }

  @override
  Future<List<MapPlaceEntity>> getNearbyBusinessesForMap({
    required double latitude,
    required double longitude,
    required double radiusKm,
  }) async {
    final models = await _syncDatasource.getNearbyBusinessesForMap(
      latitude: latitude,
      longitude: longitude,
      radiusKm: radiusKm,
    );
    return models.map(_modelToEntity).toList();
  }

  @override
  Future<List<MapPlaceEntity>> searchBusinessesOnMap(String query) async {
    final models = await _syncDatasource.searchBusinessesOnMap(query);
    return models.map(_modelToEntity).toList();
  }

  /// Converte PlaceModel (data layer) para MapPlaceEntity (domain layer)
  /// Também formata a distância de metros para string legível
  MapPlaceEntity _modelToEntity(BusinessModel model) {
    final formattedDistance = _formatDistance(model.distance);

    return MapPlaceEntity(
      id: model.id,
      name: model.name,
      description: model.description,
      category: model.category,
      latitude: model.latitude,
      longitude: model.longitude,
      rating: model.rating,
      distance: formattedDistance,
      discount: model.discountText,
      isOpen: model.isOpen,
      imageUrl: model.images?.isNotEmpty == true ? model.images!.first : null,
    );
  }

  /// Formata a distância em metros para string legível (m ou km)
  String? _formatDistance(double? distance) {
    if (distance == null) return null;

    if (distance < 1000) {
      return '${distance.toStringAsFixed(0)}m';
    } else {
      return '${(distance / 1000).toStringAsFixed(1)}km';
    }
  }
}
