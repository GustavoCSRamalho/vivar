// domain/usecases/discover/get_top_rated_businesses_usecase.dart

import 'package:discover_module/src/domain/entity/business_entity.dart';
import 'package:discover_module/src/domain/interfaces/discover_repository_protocol.dart';

class GetTopRatedBusinessesUseCase {
  final DiscoverRepositoryProtocol _repository;

  GetTopRatedBusinessesUseCase(this._repository);

  Future<List<BusinessEntity>> execute() async {
    try {
      return await _repository.getTopRatedBusinesses();
    } catch (e) {
      print('❌ Erro ao buscar lugares mais bem avaliados: $e');
      return [];
    }
  }
}
