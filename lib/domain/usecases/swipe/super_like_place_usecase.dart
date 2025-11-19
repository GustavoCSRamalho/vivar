// domain/usecases/swipe/super_like_place_usecase.dart

import 'package:vivar/domain/interface/swipe/swipe_repository_protocol.dart';

class SuperLikePlaceUseCase {
  final SwipeRepositoryProtocol _repository;

  SuperLikePlaceUseCase(this._repository);

  Future<void> execute(String userId, String placeId) async {
    try {
      await _repository.superLikePlace(userId, placeId);
    } catch (e) {
      print('❌ Erro ao dar super like: $e');
      rethrow;
    }
  }
}
