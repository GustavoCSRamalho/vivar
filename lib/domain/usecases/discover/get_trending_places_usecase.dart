// domain/usecases/discover/get_trending_businesses_usecase.dart

import 'package:vivar/domain/entity/business/business_entity.dart';
import 'package:vivar/domain/entity/place/place_entity.dart';

import '../../interface/discover/discover_repository_protocol.dart';

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
