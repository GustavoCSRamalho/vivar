// domain/repositories/place_details_repository_protocol.dart

import '../entities/place_details_entity.dart';
import '../entities/review_entity.dart';

abstract class PlaceDetailsRepositoryProtocol {
  Future<PlaceDetailsEntity?> getPlaceDetails(String placeId);
  Future<PlaceDetailsEntity?> getPlaceById(String id);
  Future<List<ReviewEntity>> getPlaceReviews(String placeId);
  Future<void> addReview(ReviewEntity review);
  Future<bool> checkIfUserReviewed(String userId, String placeId);
}
