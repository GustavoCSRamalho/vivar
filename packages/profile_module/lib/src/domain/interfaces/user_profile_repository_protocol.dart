// domain/repositories/user_profile_repository_protocol.dart

import 'package:profile_module/src/domain/entity/profile_entity.dart';
import 'package:profile_module/src/domain/entity/user_profile_update_entity.dart';

abstract class UserProfileRepositoryProtocol {
  Future<ProfileEntity?> getUserProfile(String userId);
  Future<void> updateUserProfile(UserProfileUpdateEntity profile);
  Future<String> uploadAvatar(String userId, String imagePath);
  Future<void> removeAvatar(String userId);
}
