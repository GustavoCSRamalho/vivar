// domain/usecases/discover/get_collection_businesses_usecase.dart

import 'package:discover_module/src/domain/entity/business_entity.dart';
import 'package:discover_module/src/domain/interfaces/discover_repository_protocol.dart';

class GetCollectionBusinessesUseCase {
  final DiscoverRepositoryProtocol _repository;

  GetCollectionBusinessesUseCase(this._repository);

  Future<List<BusinessEntity>> execute(String collectionId) async {
    try {
      return await _repository.getCollectionBusinesses(collectionId);
    } catch (e) {
      print('❌ Erro ao buscar lugares da coleção: $e');
      rethrow;
    }
  }
}
