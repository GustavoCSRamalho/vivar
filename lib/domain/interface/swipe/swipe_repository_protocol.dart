// domain/repositories/swipe_repository_protocol.dart

import 'package:vivar/domain/entity/swipe/swipe_place_entity.dart';

abstract class SwipeRepositoryProtocol {
  Future<List<SwipePlaceEntity>> getSwipePlaces();
  Future<void> likePlace(String userId, String placeId);
  Future<void> dislikePlace(String userId, String placeId);
  Future<void> superLikePlace(String userId, String placeId);
}
