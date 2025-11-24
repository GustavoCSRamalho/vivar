import 'package:vivar/domain/entity/profile/profile_entity.dart';
import 'package:vivar/domain/interface/profile/profile_repository_protocol.dart';
import 'package:vivar/screens/profile/data/datasource/profile/profile_sync_datasource.dart';

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
