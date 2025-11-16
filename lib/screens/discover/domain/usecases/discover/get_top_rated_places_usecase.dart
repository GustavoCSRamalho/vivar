// domain/usecases/discover/get_top_rated_places_usecase.dart

import 'package:vivar/screens/home/domain/entities/place_entity.dart';

import '../../repositories/discover_repository_protocol.dart';

class GetTopRatedPlacesUseCase {
  final DiscoverRepositoryProtocol _repository;

  GetTopRatedPlacesUseCase(this._repository);

  Future<List<PlaceEntity>> execute() async {
    try {
      return await _repository.getTopRatedPlaces();
    } catch (e) {
      print('❌ Erro ao buscar lugares mais bem avaliados: $e');
      return [];
    }
  }
}
