// domain/usecases/discover/get_trending_places_usecase.dart

import 'package:vivar/domain/entity/place/place_entity.dart';

import '../../interface/discover/discover_repository_protocol.dart';

class GetTrendingPlacesUseCase {
  final DiscoverRepositoryProtocol _repository;

  GetTrendingPlacesUseCase(this._repository);

  Future<List<PlaceEntity>> execute() async {
    try {
      return await _repository.getTrendingPlaces();
    } catch (e) {
      print('❌ Erro ao buscar lugares em alta: $e');
      return [];
    }
  }
}
