// domain/usecases/map/get_places_by_category_usecase.dart

import '../../entities/map_place_entity.dart';
import '../../repositories/map_repository_protocol.dart';

class GetPlacesByCategoryUseCase {
  final MapRepositoryProtocol _mapRepository;

  GetPlacesByCategoryUseCase(this._mapRepository);

  Future<List<MapPlaceEntity>> execute(String category) async {
    try {
      if (category == 'Todos') {
        return await _mapRepository.getPlacesForMap();
      }
      return await _mapRepository.getPlacesByCategory(category);
    } catch (e) {
      print('❌ Erro ao buscar lugares por categoria: $e');
      rethrow;
    }
  }
}
