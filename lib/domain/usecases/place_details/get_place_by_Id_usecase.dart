// domain/usecases/place/get_place_by_id_usecase.dart

import 'package:vivar/domain/entity/place/place_details_entity.dart';
import 'package:vivar/domain/interface/place/place_details_repository_protocol.dart';

class GetPlaceByIdUseCase {
  final PlaceDetailsRepositoryProtocol _placeRepository;

  GetPlaceByIdUseCase(this._placeRepository);

  Future<PlaceDetailsEntity?> execute(String placeId) async {
    try {
      if (placeId.trim().isEmpty) {
        throw Exception('ID do lugar não pode ser vazio');
      }

      return await _placeRepository.getPlaceById(placeId);
    } catch (e) {
      print('❌ Erro ao buscar lugar por ID: $e');
      rethrow;
    }
  }
}
