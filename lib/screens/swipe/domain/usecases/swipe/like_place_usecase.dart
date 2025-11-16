// domain/usecases/swipe/like_place_usecase.dart

import '../../repositories/swipe_repository_protocol.dart';

class LikePlaceUseCase {
  final SwipeRepositoryProtocol _repository;

  LikePlaceUseCase(this._repository);

  Future<void> execute(String userId, String placeId) async {
    try {
      await _repository.likePlace(userId, placeId);
    } catch (e) {
      print('❌ Erro ao dar like: $e');
      rethrow;
    }
  }
}
