// domain/usecases/swipe/like_place_usecase.dart

import 'package:vivar/domain/interface/swipe/swipe_repository_protocol.dart';

class LikeBusinessesUseCase {
  final SwipeRepositoryProtocol _repository;

  LikeBusinessesUseCase(this._repository);

  Future<void> execute(String userId, String placeId) async {
    try {
      await _repository.likeBusinesses(userId, placeId);
    } catch (e) {
      print('❌ Erro ao dar like: $e');
      rethrow;
    }
  }
}
