// domain/usecases/swipe/get_swipe_businesses_usecase.dart

import 'package:swipe_module/src/domain/entity/swipe_place_entity.dart';
import 'package:swipe_module/src/domain/interfaces/swipe_repository_protocol.dart';

class GetSwipeBusinessesUseCase {
  final SwipeRepositoryProtocol _repository;

  GetSwipeBusinessesUseCase(this._repository);

  Future<List<SwipeBusinessesEntity>> execute() async {
    try {
      return await _repository.getSwipeBusinesses();
    } catch (e) {
      print('❌ Erro ao buscar lugares para swipe: $e');
      rethrow;
    }
  }
}
