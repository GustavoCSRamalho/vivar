// domain/usecases/swipe/super_like_place_usecase.dart

import 'package:swipe_module/src/domain/interfaces/swipe_repository_protocol.dart';

class SuperLikeBusinessesUseCase {
  final SwipeRepositoryProtocol _repository;

  SuperLikeBusinessesUseCase(this._repository);

  Future<void> execute(String userId, String placeId) async {
    try {
      await _repository.superLikeBusinesses(userId, placeId);
    } catch (e) {
      print('❌ Erro ao dar super like: $e');
      rethrow;
    }
  }
}
