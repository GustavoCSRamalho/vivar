// domain/usecases/place_details/add_review_usecase.dart

import '../../entities/review_entity.dart';
import '../../repositories/place_details_repository_protocol.dart';

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
