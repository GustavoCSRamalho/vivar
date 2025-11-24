// domain/usecases/map/get_businesses_for_map_usecase.dart

import '../../entity/map/map_place_entity.dart';
import '../../interface/map/map_repository_protocol.dart';

class GetBusinessesForMapUseCase {
  final MapRepositoryProtocol _mapRepository;

  GetBusinessesForMapUseCase(this._mapRepository);

  Future<List<MapPlaceEntity>> execute() async {
    try {
      return await _mapRepository.getBusinessesForMap();
    } catch (e) {
      print('❌ Erro ao buscar lugares para mapa: $e');
      rethrow;
    }
  }
}
