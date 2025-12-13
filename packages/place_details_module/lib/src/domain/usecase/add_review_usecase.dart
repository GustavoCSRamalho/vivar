// domain/usecases/place_details/add_review_usecase.dart

import '../entity/review_entity.dart';
import '../interfaces/place_details_repository_protocol.dart';

class AddReviewUseCase {
  final PlaceDetailsRepositoryProtocol _repository;

  AddReviewUseCase(this._repository);

  Future<void> execute(ReviewEntity review) async {
    try {
      await _repository.addReview(review);
    } catch (e) {
      print('❌ Erro ao adicionar review: $e');
      rethrow;
    }
  }
}
