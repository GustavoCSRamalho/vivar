// domain/usecases/place_details/get_place_details_usecase.dart

import 'package:place_details_module/src/domain/entity/business_entity.dart';
import '../interfaces/place_details_repository_protocol.dart';

class GetPlaceDetailsUseCase {
  final PlaceDetailsRepositoryProtocol _repository;

  GetPlaceDetailsUseCase(this._repository);

  Future<BusinessEntity?> execute(String placeId) async {
    try {
      return await _repository.getPlaceDetails(placeId);
    } catch (e) {
      print('❌ Erro ao buscar detalhes do lugar: $e');
      rethrow;
    }
  }
}
