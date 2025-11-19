// domain/usecases/place/get_place_by_id_usecase.dart

import 'package:vivar/screens/place_details/domain/entities/place_details_entity.dart';
import 'package:vivar/screens/place_details/domain/repositories/place_details_repository_protocol.dart';

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
