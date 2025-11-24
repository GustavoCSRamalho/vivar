// domain/repositories/map_repository_protocol.dart

import '../../entity/map/map_place_entity.dart';

abstract class MapRepositoryProtocol {
  Future<List<MapPlaceEntity>> getBusinessesForMap();
  Future<List<MapPlaceEntity>> getBusinessesByCategory(String category);
  Future<List<MapPlaceEntity>> getNearbyBusinessesForMap({
    required double latitude,
    required double longitude,
    required double radiusKm,
  });
  Future<List<MapPlaceEntity>> searchBusinessesOnMap(String query);
}
