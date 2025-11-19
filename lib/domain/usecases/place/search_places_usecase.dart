// domain/usecases/place/search_places_usecase.dart

import '../../entity/place_entity.dart';
import '../../interface/place/place_repository_protocol.dart';

class SearchPlacesUseCase {
  final PlaceRepositoryProtocol _placeRepository;

  SearchPlacesUseCase(this._placeRepository);

  Future<List<PlaceEntity>> execute(String query) async {
    try {
      if (query.trim().isEmpty) {
        return [];
      }

      return await _placeRepository.searchPlaces(query.trim());
    } catch (e) {
      print('❌ Erro ao buscar lugares: $e');
      rethrow;
    }
  }
}
