// domain/usecases/swipe/get_swipe_businesses_usecase.dart

import 'package:vivar/domain/entity/swipe/swipe_place_entity.dart';
import 'package:vivar/domain/interface/swipe/swipe_repository_protocol.dart';

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
