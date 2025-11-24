// domain/repositories/place_details_repository_protocol.dart

import 'package:vivar/domain/entity/business/business_entity.dart';

import '../../entity/place/place_details_entity.dart';
import '../../entity/review/review_entity.dart';

abstract class PlaceDetailsRepositoryProtocol {
  Future<BusinessEntity?> getPlaceDetails(String placeId);
  Future<BusinessEntity?> getPlaceById(String id);
  Future<List<ReviewEntity>> getPlaceReviews(String placeId);
  Future<void> addReview(ReviewEntity review);
  Future<bool> checkIfUserReviewed(String userId, String placeId);
}
