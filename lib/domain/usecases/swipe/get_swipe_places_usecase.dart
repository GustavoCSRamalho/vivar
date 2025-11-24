// domain/usecases/swipe/get_swipe_businesses_usecase.dart

import 'package:vivar/domain/entity/swipe/swipe_place_entity.dart';
import 'package:vivar/domain/interface/swipe/swipe_repository_protocol.dart';

class GetSwipePlacesUseCase {
  final SwipeRepositoryProtocol _repository;

  GetSwipePlacesUseCase(this._repository);

  Future<List<SwipePlaceEntity>> execute() async {
    try {
      return await _repository.getSwipePlaces();
    } catch (e) {
      print('❌ Erro ao buscar lugares para swipe: $e');
      rethrow;
    }
  }
}
