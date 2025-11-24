// domain/repositories/swipe_repository_protocol.dart

import 'package:vivar/domain/entity/swipe/swipe_place_entity.dart';

abstract class SwipeRepositoryProtocol {
  Future<List<SwipeBusinessesEntity>> getSwipeBusinesses();
  Future<void> likeBusinesses(String userId, String BusinessesId);
  Future<void> dislikeBusinesses(String userId, String BusinessesId);
  Future<void> superLikeBusinesses(String userId, String BusinessesId);
}
