// domain/usecases/map/get_businesses_by_category_usecase.dart

import 'package:map_module/src/domain/entity/map_place_entity.dart';
import 'package:map_module/src/domain/interfaces/map_repository_protocol.dart';

class GetBusinessesByCategoryUseCase {
  final MapRepositoryProtocol _mapRepository;

  GetBusinessesByCategoryUseCase(this._mapRepository);

  Future<List<MapPlaceEntity>> execute(String category) async {
    try {
      if (category == 'Todos') {
        return await _mapRepository.getBusinessesForMap();
      }
      return await _mapRepository.getBusinessesByCategory(category);
    } catch (e) {
      print('❌ Erro ao buscar lugares por categoria: $e');
      rethrow;
    }
  }
}
