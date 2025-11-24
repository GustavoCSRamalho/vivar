// domain/usecases/map/search_businesses_on_map_usecase.dart

import '../../entity/map/map_place_entity.dart';
import '../../interface/map/map_repository_protocol.dart';

class SearchPlacesOnMapUseCase {
  final MapRepositoryProtocol _mapRepository;

  SearchPlacesOnMapUseCase(this._mapRepository);

  Future<List<MapPlaceEntity>> execute(String query) async {
    try {
      if (query.trim().isEmpty) {
        return [];
      }
      return await _mapRepository.searchPlacesOnMap(query.trim());
    } catch (e) {
      print('❌ Erro ao buscar lugares no mapa: $e');
      rethrow;
    }
  }
}
