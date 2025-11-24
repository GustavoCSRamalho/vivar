// data/repositories/user_profile_repository_impl.dart

import 'dart:convert';
import 'package:vivar/domain/entity/profile/profile_entity.dart';
import 'package:vivar/domain/entity/user/user_profile_update_entity.dart';
import 'package:vivar/models/user_model.dart';
import 'package:vivar/domain/interface/user/user_profile_repository_protocol.dart';

import '../datasource/user/profile_user_local_sync_datasource.dart';

class UserProfileRepositoryImpl implements UserProfileRepositoryProtocol {
  final UserLocalSyncDataSource _syncDatasource;

  UserProfileRepositoryImpl({required UserLocalSyncDataSource syncDatasource})
    : _syncDatasource = syncDatasource;

  @override
  Future<ProfileEntity?> getUserProfile(String userId) async {
    final model = await _syncDatasource.getUser(userId);
    if (model == null) return null;

    return _modelToEntity(model);
  }

  @override
  Future<void> updateUserProfile(UserProfileUpdateEntity profile) async {
    final updateData = <String, dynamic>{'name': profile.name.trim()};

    if (profile.username != null) updateData['username'] = profile.username;
    if (profile.bio != null) updateData['bio'] = profile.bio;
    if (profile.phone != null) updateData['phone'] = profile.phone;
    if (profile.location != null) updateData['location'] = profile.location;
    if (profile.avatarUrl != null) updateData['avatar_url'] = profile.avatarUrl;
    if (profile.interests != null)
      updateData['interests'] = jsonEncode(profile.interests);
    if (profile.privacySettings != null) {
      updateData['privacy_settings'] = jsonEncode(profile.privacySettings);
    }

    await _syncDatasource.updateUser(updateData, profile.userId);
  }

  @override
  Future<String> uploadAvatar(String userId, String imagePath) async {
    await Future.delayed(Duration(seconds: 1));
    final url = "https://example.com/avatars/$userId.jpg";

    await _syncDatasource.updateAvatar(userId, url);

    return url;
  }

  @override
  Future<void> removeAvatar(String userId) async {
    await _syncDatasource.removeAvatar(userId);
  }

  ProfileEntity _modelToEntity(UserModel model) {
    return ProfileEntity(
      id: model.id,
      email: model.email,
      name: model.name,
      username: model.username,
      avatarUrl: model.avatarUrl,
      bio: model.bio,
      phone: model.phone,
      location: model.location,
      planType: model.planType,
      points: model.points,
      businessesVisited: model.businessesVisited,
      badgesCount: model.badgesCount,
      streakDays: model.streakDays,
      favoriteCount: model.favoriteCount,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }
}
