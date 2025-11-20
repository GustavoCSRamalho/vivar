import 'package:vivar/domain/entity/profile/profile_entity.dart';
import 'package:vivar/domain/interface/profile/profile_repository_protocol.dart';
import 'package:vivar/screens/profile/data/datasource/profile_local_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepositoryProtocol {
  final ProfileLocalDataSourceProtocol datasource;

  ProfileRepositoryImpl({required this.datasource});

  @override
  Future<ProfileEntity?> getProfile(String userId) {
    return datasource.getProfile(userId);
  }

  @override
  Future<void> updateProfile(ProfileEntity profile) {
    return datasource.updateProfile(profile);
  }

  @override
  Future<int> getRecentCheckinsCount(String userId) {
    return datasource.getRecentCheckinsCount(userId);
  }

  @override
  Future<List<String>> getRecentBadges(String userId, {int limit = 5}) {
    return datasource.getRecentBadges(userId, limit: limit);
  }
}
