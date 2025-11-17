// domain/repositories/user_profile_repository_protocol.dart

import '../entities/profile_entity.dart';
import '../entities/user_profile_update_entity.dart';

abstract class UserProfileRepositoryProtocol {
  Future<ProfileEntity?> getUserProfile(String userId);
  Future<void> updateUserProfile(UserProfileUpdateEntity profile);
  Future<String> uploadAvatar(String userId, String imagePath);
  Future<void> removeAvatar(String userId);
}
