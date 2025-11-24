// domain/usecases/place/get_businesses_with_discount_usecase.dart

import 'package:vivar/domain/entity/business/business_entity.dart';
import 'package:vivar/domain/entity/place/place_entity.dart';
import 'package:vivar/domain/interface/place/place_repository_protocol.dart';

class GetBusinessesWithDiscountUseCase {
  final BusinessesRepositoryProtocol _placeRepository;

  GetBusinessesWithDiscountUseCase(this._placeRepository);

  Future<List<BusinessEntity>> execute() async {
    try {
      return await _placeRepository.getBusinessesWithDiscount();
    } catch (e) {
      print('❌ Erro ao buscar lugares com desconto: $e');
      rethrow;
    }
  }
}
