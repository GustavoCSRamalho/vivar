// domain/usecases/swipe/dislike_place_usecase.dart

import '../../repositories/swipe_repository_protocol.dart';

class DislikePlaceUseCase {
  final SwipeRepositoryProtocol _repository;

  DislikePlaceUseCase(this._repository);

  Future<void> execute(String userId, String placeId) async {
    try {
      await _repository.dislikePlace(userId, placeId);
    } catch (e) {
      print('❌ Erro ao dar dislike: $e');
      rethrow;
    }
  }
}
