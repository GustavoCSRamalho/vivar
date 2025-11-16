// domain/usecases/place/get_top_rated_places_usecase.dart

import '../../entities/place_entity.dart';
import '../../repositories/place_repository_protocol.dart';

class GetTopRatedPlacesUseCase {
  final PlaceRepositoryProtocol _placeRepository;

  GetTopRatedPlacesUseCase(this._placeRepository);

  Future<List<PlaceEntity>> execute({int limit = 10}) async {
    try {
      return await _placeRepository.getTopRatedPlaces(limit: limit);
    } catch (e) {
      print('❌ Erro ao buscar lugares top rated: $e');
      rethrow;
    }
  }
}
