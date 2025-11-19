// data/repositories/user_profile_repository_impl.dart

import 'package:sqflite/sqflite.dart';
import 'package:vivar/core/database/database_helper.dart';
import 'package:vivar/models/user_model.dart';
import 'package:vivar/domain/entity/profile_entity.dart';
import 'package:vivar/domain/entity/user_profile_update_entity.dart';
import 'dart:convert';

import 'package:vivar/domain/interface/user/user_profile_repository_protocol.dart';

class UserProfileRepositoryImpl implements UserProfileRepositoryProtocol {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final String _userTableName = 'users';

  Future<Database> get _database async => await _dbHelper.database;

  @override
  Future<ProfileEntity?> getUserProfile(String userId) async {
    final db = await _database;
    final List<Map<String, dynamic>> maps = await db.query(
      _userTableName,
      where: 'id = ?',
      whereArgs: [userId],
      limit: 1,
    );

    if (maps.isEmpty) return null;
    return _modelToEntity(UserModel.fromMap(maps.first));
  }

  @override
  Future<void> updateUserProfile(UserProfileUpdateEntity profile) async {
    final db = await _database;

    final updateData = <String, dynamic>{
      'name': profile.name.trim(),
      'updated_at': DateTime.now().toIso8601String(),
    };

    if (profile.username != null) {
      updateData['username'] = profile.username!.trim();
    }

    if (profile.bio != null) {
      updateData['bio'] = profile.bio!.trim();
    }

    if (profile.phone != null) {
      updateData['phone'] = profile.phone!.trim();
    }

    if (profile.location != null) {
      updateData['location'] = profile.location!.trim();
    }

    if (profile.avatarUrl != null) {
      updateData['avatar_url'] = profile.avatarUrl;
    }

    if (profile.interests != null) {
      updateData['interests'] = jsonEncode(profile.interests);
    }

    if (profile.privacySettings != null) {
      updateData['privacy_settings'] = jsonEncode(profile.privacySettings);
    }

    await db.update(
      _userTableName,
      updateData,
      where: 'id = ?',
      whereArgs: [profile.userId],
    );
  }

  @override
  Future<String> uploadAvatar(String userId, String imagePath) async {
    // Simular upload - em produção, seria upload para cloud storage
    await Future.delayed(Duration(seconds: 1));

    final avatarUrl = 'https://example.com/avatars/$userId.jpg';

    final db = await _database;
    await db.update(
      _userTableName,
      {'avatar_url': avatarUrl, 'updated_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [userId],
    );

    return avatarUrl;
  }

  @override
  Future<void> removeAvatar(String userId) async {
    final db = await _database;
    await db.update(
      _userTableName,
      {'avatar_url': null, 'updated_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [userId],
    );
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
      placesVisited: model.placesVisited,
      badgesCount: model.badgesCount,
      streakDays: model.streakDays,
      favoriteCount: model.favoriteCount,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }
}
