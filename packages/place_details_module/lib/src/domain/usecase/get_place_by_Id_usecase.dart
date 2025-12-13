// domain/usecases/place/get_place_by_id_usecase.dart

import 'package:place_details_module/src/domain/entity/business_entity.dart';
import '../interfaces/place_details_repository_protocol.dart';

class GetPlaceByIdUseCase {
  final PlaceDetailsRepositoryProtocol _placeRepository;

  GetPlaceByIdUseCase(this._placeRepository);

  Future<BusinessEntity?> execute(String placeId) async {
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
