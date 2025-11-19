// domain/usecases/discover/get_collections_usecase.dart

import '../../entity/discover_collection_entity.dart';
import '../../interface/discover/discover_repository_protocol.dart';

class GetCollectionsUseCase {
  final DiscoverRepositoryProtocol _repository;

  GetCollectionsUseCase(this._repository);

  Future<List<DiscoverCollectionEntity>> execute() async {
    try {
      return await _repository.getCollections();
    } catch (e) {
      print('❌ Erro ao buscar coleções: $e');
      rethrow;
    }
  }
}
