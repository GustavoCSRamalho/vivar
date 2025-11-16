// domain/usecases/discover/get_near_you_places_usecase.dart

import 'package:vivar/screens/home/domain/entities/place_entity.dart';

import '../../repositories/discover_repository_protocol.dart';

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
