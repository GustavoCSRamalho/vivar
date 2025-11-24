// domain/usecases/place/get_businesses_with_discount_usecase.dart

import 'package:vivar/domain/entity/business/business_entity.dart';
import 'package:vivar/domain/entity/place/place_entity.dart';
import 'package:vivar/domain/interface/place/place_repository_protocol.dart';

class GetPlacesWithDiscountUseCase {
  final PlaceRepositoryProtocol _placeRepository;

  GetPlacesWithDiscountUseCase(this._placeRepository);

  Future<List<BusinessEntity>> execute() async {
    try {
      return await _placeRepository.getPlacesWithDiscount();
    } catch (e) {
      print('❌ Erro ao buscar lugares com desconto: $e');
      rethrow;
    }
  }
}
