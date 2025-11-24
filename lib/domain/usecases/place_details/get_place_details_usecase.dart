// domain/usecases/place_details/get_place_details_usecase.dart

import 'package:vivar/domain/entity/business/business_entity.dart';

import '../../entity/place/place_details_entity.dart';
import '../../interface/place/place_details_repository_protocol.dart';

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
