// data/datasources/user/user_local_remote_datasource_protocol.dart
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class UserLocalRemoteDatasourceProtocol {
  Future<void> updateUser(Map<String, dynamic> data, String userId);
  Future<void> updateAvatar(String userId, String url);
  Future<void> removeAvatar(String userId);
}

// data/datasources/user/user_local_remote_datasource_impl.dart

class UserLocalRemoteDatasourceImpl
    implements UserLocalRemoteDatasourceProtocol {
  final SupabaseClient _supabase;

  UserLocalRemoteDatasourceImpl({SupabaseClient? supabase})
    : _supabase = supabase ?? Supabase.instance.client;

  @override
  Future<void> updateUser(Map<String, dynamic> data, String userId) async {
    try {
      final updateData = {
        ...data,
        'updated_at': DateTime.now().toIso8601String(),
      };

      await _supabase.from('users').update(updateData).eq('id', userId);
    } catch (e) {
      print('❌ Erro ao atualizar usuário remoto: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateAvatar(String userId, String url) async {
    try {
      await _supabase
          .from('users')
          .update({
            'avatar_url': url,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', userId);
    } catch (e) {
      print('❌ Erro ao atualizar avatar remoto: $e');
      rethrow;
    }
  }

  @override
  Future<void> removeAvatar(String userId) async {
    try {
      await _supabase
          .from('users')
          .update({
            'avatar_url': null,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', userId);
    } catch (e) {
      print('❌ Erro ao remover avatar remoto: $e');
      rethrow;
    }
  }
}
