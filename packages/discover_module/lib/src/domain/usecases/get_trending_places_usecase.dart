// domain/usecases/discover/get_trending_businesses_usecase.dart

import 'package:discover_module/src/domain/entity/business_entity.dart';
import 'package:discover_module/src/domain/interfaces/discover_repository_protocol.dart';

class GetTrendingBusinessesUseCase {
  final DiscoverRepositoryProtocol _repository;

  GetTrendingBusinessesUseCase(this._repository);

  Future<List<BusinessEntity>> execute() async {
    try {
      return await _repository.getTrendingBusinesses();
    } catch (e) {
      print('❌ Erro ao buscar lugares em alta: $e');
      return [];
    }
  }
}
