// domain/usecases/place/get_places_with_discount_usecase.dart

import 'package:vivar/domain/interface/place/place_repository_protocol.dart';

import '../../entity/place_entity.dart';

class GetPlacesWithDiscountUseCase {
  final PlaceRepositoryProtocol _placeRepository;

  GetPlacesWithDiscountUseCase(this._placeRepository);

  Future<List<PlaceEntity>> execute() async {
    try {
      return await _placeRepository.getPlacesWithDiscount();
    } catch (e) {
      print('❌ Erro ao buscar lugares com desconto: $e');
      rethrow;
    }
  }
}
