// domain/usecases/place/get_all_places_usecase.dart

import '../../entities/place_entity.dart';
import '../../repositories/place_repository_protocol.dart';

class GetAllPlacesUseCase {
  final PlaceRepositoryProtocol _placeRepository;

  GetAllPlacesUseCase(this._placeRepository);

  Future<List<PlaceEntity>> execute() async {
    try {
      return await _placeRepository.getAllPlaces();
    } catch (e) {
      print('❌ Erro ao buscar todos os lugares: $e');
      rethrow;
    }
  }
}
