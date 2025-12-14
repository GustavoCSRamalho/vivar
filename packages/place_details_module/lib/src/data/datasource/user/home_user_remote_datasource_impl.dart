// data/datasources/user/user_remote_datasource_protocol.dart

import 'package:place_details_module/src/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class UserRemoteDatasourceProtocol {
  Future<UserModel?> getUserById(String id);
  Future<List<String>> getUserFavoritePlaceIds(String userId);
  Future<Map<String, dynamic>> getSyncData(String userId, DateTime? lastSync);
}

// data/datasources/user/user_remote_datasource_impl.dart

class UserRemoteDatasourceImpl implements UserRemoteDatasourceProtocol {
  final SupabaseClient _supabase;

  UserRemoteDatasourceImpl({SupabaseClient? supabase})
    : _supabase = supabase ?? Supabase.instance.client;

  @override
  Future<UserModel?> getUserById(String id) async {
    try {
      final response = await _supabase
          .from('users')
          .select()
          .eq('id', id)
          .maybeSingle();

      if (response == null) return null;
      return UserModel.fromMap(response);
    } catch (e) {
      print('❌ Erro ao buscar usuário remoto: $e');
      return null;
    }
  }

  @override
  Future<List<String>> getUserFavoritePlaceIds(String userId) async {
    try {
      final response = await _supabase
          .from('favorites')
          .select('place_id')
          .eq('user_id', userId);

      return (response as List)
          .map((item) => item['place_id'] as String)
          .toList();
    } catch (e) {
      print('❌ Erro ao buscar favoritos remotos: $e');
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

      // Query para favoritos
      var favoritesQuery = _supabase
          .from('favorites')
          .select()
          .eq('user_id', userId);

      if (lastSync != null) {
        favoritesQuery = favoritesQuery.gt(
          'updated_at',
          lastSync.toIso8601String(),
        );
      }

      final userResponse = await userQuery.maybeSingle();
      final favoritesResponse = await favoritesQuery;

      return {
        'user': userResponse,
        'favorites': favoritesResponse as List? ?? [],
      };
    } catch (e) {
      print('❌ Erro ao buscar dados de sincronização: $e');
      return {'user': null, 'favorites': []};
    }
  }
}
