// domain/usecases/discover/get_collection_places_usecase.dart

import 'package:vivar/screens/home/domain/entities/place_entity.dart';

import '../../repositories/discover_repository_protocol.dart';

class GetCollectionPlacesUseCase {
  final DiscoverRepositoryProtocol _repository;

  GetCollectionPlacesUseCase(this._repository);

  Future<List<PlaceEntity>> execute(String collectionId) async {
    try {
      return await _repository.getCollectionPlaces(collectionId);
    } catch (e) {
      print('❌ Erro ao buscar lugares da coleção: $e');
      rethrow;
    }
  }
}
