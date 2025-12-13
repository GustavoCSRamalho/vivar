// domain/repositories/profile_repository_protocol.dart

import 'package:profile_module/src/domain/entity/profile_entity.dart';

abstract class ProfileRepositoryProtocol {
  Future<ProfileEntity?> getProfile(String userId);
  Future<void> updateProfile(ProfileEntity profile);
  Future<int> getRecentCheckinsCount(String userId);
  Future<List<String>> getRecentBadges(String userId, {int limit = 5});
}
