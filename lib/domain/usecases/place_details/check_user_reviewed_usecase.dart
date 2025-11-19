// domain/usecases/place_details/check_user_reviewed_usecase.dart

import '../../interface/place/place_details_repository_protocol.dart';

class CheckUserReviewedUseCase {
  final PlaceDetailsRepositoryProtocol _repository;

  CheckUserReviewedUseCase(this._repository);

  Future<bool> execute(String userId, String placeId) async {
    try {
      return await _repository.checkIfUserReviewed(userId, placeId);
    } catch (e) {
      print('❌ Erro ao verificar review: $e');
      return false;
    }
  }
}
