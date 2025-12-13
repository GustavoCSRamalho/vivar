import 'package:profile_module/src/domain/entity/profile_entity.dart';
import 'package:profile_module/src/domain/interfaces/profile_repository_protocol.dart';
import '../datasource/profile/profile_sync_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepositoryProtocol {
  final ProfileSyncDataSource _syncDatasource;

  ProfileRepositoryImpl({required ProfileSyncDataSource syncDatasource})
    : _syncDatasource = syncDatasource;

  @override
  Future<ProfileEntity?> getProfile(String userId) {
    return _syncDatasource.getProfile(userId);
  }

  @override
  Future<void> updateProfile(ProfileEntity profile) {
    return _syncDatasource.updateProfile(profile);
  }

  @override
  Future<int> getRecentCheckinsCount(String userId) {
    return _syncDatasource.getRecentCheckinsCount(userId);
  }

  @override
  Future<List<String>> getRecentBadges(String userId, {int limit = 5}) {
    return _syncDatasource.getRecentBadges(userId, limit: limit);
  }
}
