// domain/usecases/place/get_top_rated_businesses_usecase.dart

import 'package:vivar/domain/entity/business/business_entity.dart';

import '../../entity/place/place_entity.dart';
import '../../interface/place/place_repository_protocol.dart';

class GetTopRatedBusinessesUseCase {
  final BusinessesRepositoryProtocol _placeRepository;

  GetTopRatedBusinessesUseCase(this._placeRepository);

  Future<List<BusinessEntity>> execute({int limit = 10}) async {
    try {
      return await _placeRepository.getTopRatedBusinesses(limit: limit);
    } catch (e) {
      print('❌ Erro ao buscar lugares top rated: $e');
      rethrow;
    }
  }
}
