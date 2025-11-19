// domain/repositories/user_repository_protocol.dart

import '../../entity/user_entity.dart';

abstract class UserRepositoryProtocol {
  Future<UserEntity?> getCurrentUser();

  Future<UserEntity?> getUserById(String id);

  Future<void> updateUser(UserEntity user);

  Future<List<String>> getUserFavoritePlaceIds(String userId);

  Future<void> addFavorite(String userId, String placeId);

  Future<void> removeFavorite(String userId, String placeId);

  Future<bool> toggleFavorite(String userId, String placeId);
}
