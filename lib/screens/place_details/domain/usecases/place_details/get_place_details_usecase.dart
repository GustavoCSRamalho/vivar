// domain/usecases/place_details/get_place_details_usecase.dart

import '../../entities/place_details_entity.dart';
import '../../repositories/place_details_repository_protocol.dart';

class GetPlaceDetailsUseCase {
  final PlaceDetailsRepositoryProtocol _repository;

  GetPlaceDetailsUseCase(this._repository);

  Future<PlaceDetailsEntity?> execute(String placeId) async {
    try {
      return await _repository.getPlaceDetails(placeId);
    } catch (e) {
      print('❌ Erro ao buscar detalhes do lugar: $e');
      rethrow;
    }
  }
}
