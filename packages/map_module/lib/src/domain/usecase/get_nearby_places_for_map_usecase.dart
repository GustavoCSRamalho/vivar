// domain/usecases/map/get_nearby_businesses_for_map_usecase.dart

import 'package:map_module/src/domain/entity/map_place_entity.dart';
import 'package:map_module/src/domain/interfaces/map_repository_protocol.dart';

class GetNearbyBusinessesForMapUseCase {
  final MapRepositoryProtocol _mapRepository;

  GetNearbyBusinessesForMapUseCase(this._mapRepository);

  Future<List<MapPlaceEntity>> execute({
    required double latitude,
    required double longitude,
    double radiusKm = 5.0,
  }) async {
    try {
      return await _mapRepository.getNearbyBusinessesForMap(
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
