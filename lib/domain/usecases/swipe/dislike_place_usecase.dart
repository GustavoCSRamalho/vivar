// domain/usecases/swipe/dislike_place_usecase.dart

import 'package:vivar/domain/interface/swipe/swipe_repository_protocol.dart';

class DislikeBusinessesUseCase {
  final SwipeRepositoryProtocol _repository;

  DislikeBusinessesUseCase(this._repository);

  Future<void> execute(String userId, String placeId) async {
    try {
      await _repository.dislikeBusinesses(userId, placeId);
    } catch (e) {
      print('❌ Erro ao dar dislike: $e');
      rethrow;
    }
  }
}
