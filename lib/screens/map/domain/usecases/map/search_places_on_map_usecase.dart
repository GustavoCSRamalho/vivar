// domain/usecases/map/search_places_on_map_usecase.dart

import '../../entities/map_place_entity.dart';
import '../../repositories/map_repository_protocol.dart';

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
