// domain/usecases/discover/get_near_you_businesses_usecase.dart

import 'package:discover_module/src/domain/entity/business_entity.dart';
import 'package:discover_module/src/domain/interfaces/discover_repository_protocol.dart';

class GetNearYouBusinessesUseCase {
  final DiscoverRepositoryProtocol _repository;

  GetNearYouBusinessesUseCase(this._repository);

  Future<List<BusinessEntity>> execute() async {
    try {
      return await _repository.getNearYouBusinesses();
    } catch (e) {
      print('❌ Erro ao buscar lugares próximos: $e');
      return [];
    }
  }
}
