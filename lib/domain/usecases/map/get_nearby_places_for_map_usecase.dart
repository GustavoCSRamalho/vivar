// domain/usecases/map/get_nearby_places_for_map_usecase.dart

import '../../entity/map_place_entity.dart';
import '../../interface/map/map_repository_protocol.dart';

class GetNearbyPlacesForMapUseCase {
  final MapRepositoryProtocol _mapRepository;

  GetNearbyPlacesForMapUseCase(this._mapRepository);

  Future<List<MapPlaceEntity>> execute({
    required double latitude,
    required double longitude,
    double radiusKm = 5.0,
  }) async {
    try {
      return await _mapRepository.getNearbyPlacesForMap(
        latitude: latitude,
        longitude: longitude,
        radiusKm: radiusKm,
      );
    } catch (e) {
      print('❌ Erro ao buscar lugares próximos no mapa: $e');
      rethrow;
    }
  }
}
