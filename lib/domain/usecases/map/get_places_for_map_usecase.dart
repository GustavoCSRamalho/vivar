// domain/usecases/map/get_places_for_map_usecase.dart

import '../../entity/map_place_entity.dart';
import '../../interface/map/map_repository_protocol.dart';

class GetPlacesForMapUseCase {
  final MapRepositoryProtocol _mapRepository;

  GetPlacesForMapUseCase(this._mapRepository);

  Future<List<MapPlaceEntity>> execute() async {
    try {
      return await _mapRepository.getPlacesForMap();
    } catch (e) {
      print('❌ Erro ao buscar lugares para mapa: $e');
      rethrow;
    }
  }
}
