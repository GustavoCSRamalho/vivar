// domain/usecases/map/search_businesses_on_map_usecase.dart

import 'package:map_module/src/domain/entity/map_place_entity.dart';
import 'package:map_module/src/domain/interfaces/map_repository_protocol.dart';

class SearchBusinessesOnMapUseCase {
  final MapRepositoryProtocol _mapRepository;

  SearchBusinessesOnMapUseCase(this._mapRepository);

  Future<List<MapPlaceEntity>> execute(String query) async {
    try {
      if (query.trim().isEmpty) {
        return [];
      }
      return await _mapRepository.searchBusinessesOnMap(query.trim());
    } catch (e) {
      print('❌ Erro ao buscar lugares no mapa: $e');
      rethrow;
    }
  }
}
