// domain/repositories/map_repository_protocol.dart

import '../entities/map_place_entity.dart';

abstract class MapRepositoryProtocol {
  Future<List<MapPlaceEntity>> getPlacesForMap();
  Future<List<MapPlaceEntity>> getPlacesByCategory(String category);
  Future<List<MapPlaceEntity>> getNearbyPlacesForMap({
    required double latitude,
    required double longitude,
    required double radiusKm,
  });
  Future<List<MapPlaceEntity>> searchPlacesOnMap(String query);
}
