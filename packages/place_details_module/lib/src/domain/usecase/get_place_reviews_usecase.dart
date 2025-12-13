// domain/usecases/place_details/get_place_reviews_usecase.dart

import '../entity/review_entity.dart';
import '../interfaces/place_details_repository_protocol.dart';

class GetPlaceReviewsUseCase {
  final PlaceDetailsRepositoryProtocol _repository;

  GetPlaceReviewsUseCase(this._repository);

  Future<List<ReviewEntity>> execute(String placeId) async {
    try {
      return await _repository.getPlaceReviews(placeId);
    } catch (e) {
      print('❌ Erro ao buscar reviews: $e');
      return [];
    }
  }
}
