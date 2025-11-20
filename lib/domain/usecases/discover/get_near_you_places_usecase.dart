// domain/usecases/discover/get_near_you_places_usecase.dart

import 'package:vivar/domain/entity/place/place_entity.dart';

import '../../interface/discover/discover_repository_protocol.dart';

class GetNearYouPlacesUseCase {
  final DiscoverRepositoryProtocol _repository;

  GetNearYouPlacesUseCase(this._repository);

  Future<List<PlaceEntity>> execute() async {
    try {
      return await _repository.getNearYouPlaces();
    } catch (e) {
      print('❌ Erro ao buscar lugares próximos: $e');
      return [];
    }
  }
}
