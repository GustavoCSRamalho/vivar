// data/datasources/profile/profile_remote_datasource_protocol.dart

import 'package:profile_module/src/data/models/user_model.dart';
import 'package:profile_module/src/domain/entity/profile_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class ProfileRemoteDatasourceProtocol {
  Future<ProfileEntity?> getProfile(String userId);
  Future<void> updateProfile(ProfileEntity profile);
  Future<int> getRecentCheckinsCount(String userId);
  Future<List<String>> getRecentBadges(String userId, {int limit = 5});
  Future<Map<String, dynamic>> getSyncData(String userId, DateTime? lastSync);
}

// data/datasources/profile/profile_remote_datasource_impl.dart

class ProfileRemoteDatasourceImpl implements ProfileRemoteDatasourceProtocol {
  final SupabaseClient _supabase;

  ProfileRemoteDatasourceImpl({SupabaseClient? supabase})
    : _supabase = supabase ?? Supabase.instance.client;

  @override
  Future<ProfileEntity?> getProfile(String userId) async {
    try {
      final response = await _supabase
          .from('users')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (response == null) return null;
      final model = UserModel.fromMap(response);
      return _modelToEntity(model);
    } catch (e) {
      print('❌ Erro ao buscar perfil remoto: $e');
      return null;
    }
  }

  @override
  Future<void> updateProfile(ProfileEntity profile) async {
    try {
      final model = _entityToModel(profile);
      await _supabase
          .from('users')
          .update({
            ...model.toMap(),
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', profile.id);
    } catch (e) {
      print('❌ Erro ao atualizar perfil remoto: $e');
      rethrow;
    }
  }

  @override
  Future<int> getRecentCheckinsCount(String userId) async {
    try {
      final thirtyDaysAgo = DateTime.now().subtract(Duration(days: 30));

      final response = await _supabase
          .from('checkins')
          .select('id')
          .eq('user_id', userId)
          .gte('created_at', thirtyDaysAgo.toIso8601String());

      return (response as List).length;
    } catch (e) {
      print('❌ Erro ao buscar checkins remotos: $e');
      return 0;
    }
  }

  @override
  Future<List<String>> getRecentBadges(String userId, {int limit = 5}) async {
    try {
      final response = await _supabase
          .from('badges')
          .select('badge_type')
          .eq('user_id', userId)
          .order('earned_at', ascending: false)
          .limit(limit);

      return (response as List)
          .map((item) => item['badge_type'] as String)
          .toList();
    } catch (e) {
      print('❌ Erro ao buscar badges remotas: $e');
      return [];
    }
  }

  @override
  Future<Map<String, dynamic>> getSyncData(
    String userId,
    DateTime? lastSync,
  ) async {
    try {
      // Query para usuário
      var userQuery = _supabase.from('users').select().eq('id', userId);

      if (lastSync != null) {
        userQuery = userQuery.gt('updated_at', lastSync.toIso8601String());
      }

      // Query para checkins
      var checkinsQuery = _supabase
          .from('checkins')
          .select()
          .eq('user_id', userId);

      if (lastSync != null) {
        checkinsQuery = checkinsQuery.gt(
          'updated_at',
          lastSync.toIso8601String(),
        );
      }

      // Query para badges
      var badgesQuery = _supabase.from('badges').select().eq('user_id', userId);

      if (lastSync != null) {
        badgesQuery = badgesQuery.gt('updated_at', lastSync.toIso8601String());
      }

      final userResponse = await userQuery.maybeSingle();
      final checkinsResponse = await checkinsQuery;
      final badgesResponse = await badgesQuery;

      return {
        'user': userResponse,
        'checkins': checkinsResponse as List? ?? [],
        'badges': badgesResponse as List? ?? [],
      };
    } catch (e) {
      print('❌ Erro ao buscar dados de sincronização do perfil: $e');
      return {'user': null, 'checkins': [], 'badges': []};
    }
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

  UserModel _entityToModel(ProfileEntity entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      name: entity.name,
      username: entity.username,
      avatarUrl: entity.avatarUrl,
      bio: entity.bio,
      phone: entity.phone,
      location: entity.location,
      planType: entity.planType,
      points: entity.points,
      businessesVisited: entity.businessesVisited,
      badgesCount: entity.badgesCount,
      streakDays: entity.streakDays,
      favoriteCount: entity.favoriteCount,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
