// data/datasources/swipe/swipe_remote_datasource_protocol.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:swipe_module/src/data/models/business_model.dart';

abstract class SwipeRemoteDatasourceProtocol {
  Future<List<BusinessModel>> getSwipeBusinesses({int limit = 50});
  Future<void> likeBusinesses(String userId, String businessesId);
  Future<void> superLikeBusinesses(String userId, String businessesId);
  Future<void> dislikeBusinesses(String userId, String businessesId);
  Future<Map<String, dynamic>> getSyncData(String userId, DateTime? lastSync);
}
// data/datasources/swipe/swipe_remote_datasource_impl.dart

class SwipeRemoteDatasourceImpl implements SwipeRemoteDatasourceProtocol {
  final SupabaseClient _supabase;

  SwipeRemoteDatasourceImpl({SupabaseClient? supabase})
    : _supabase = supabase ?? Supabase.instance.client;

  @override
  Future<List<BusinessModel>> getSwipeBusinesses({int limit = 50}) async {
    try {
      // Busca lugares aleatórios usando função do PostgreSQL
      final response = await _supabase.rpc(
        'get_random_businesses',
        params: {'limit_count': limit},
      );

      return (response as List)
          .map((data) => BusinessModel.fromMap(data))
          .toList();

      /* 
      // Alternativa simples (menos eficiente):
      final response = await _supabase
          .from('businesses')
          .select()
          .limit(limit);

      final businesses = (response as List)
          .map((data) => PlaceModel.fromMap(data))
          .toList();
      
      businesses.shuffle(); // Embaralha localmente
      return businesses;
      */
    } catch (e) {
      print('❌ Erro ao buscar lugares para swipe remotos: $e');
      return [];
    }
  }

  @override
  Future<void> likeBusinesses(String userId, String businessesId) async {
    try {
      await _supabase.from('favorites').insert({
        'user_id': userId,
        'businesses_id': businessesId,
        'is_super_like': false,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('❌ Erro ao dar like remoto: $e');
      rethrow;
    }
  }

  @override
  Future<void> superLikeBusinesses(String userId, String businessesId) async {
    try {
      await _supabase.from('favorites').insert({
        'user_id': userId,
        'businesses_id': businessesId,
        'is_super_like': true,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('❌ Erro ao dar super like remoto: $e');
      rethrow;
    }
  }

  @override
  Future<void> dislikeBusinesses(String userId, String vusinessesId) async {
    try {
      await _supabase.from('dislikes').insert({
        'user_id': userId,
        'businesses_id': vusinessesId,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('❌ Erro ao dar dislike remoto: $e');
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> getSyncData(
    String userId,
    DateTime? lastSync,
  ) async {
    try {
      // Query para favoritos
      var favoritesQuery = _supabase
          .from('favorites')
          .select()
          .eq('user_id', userId);

      if (lastSync != null) {
        favoritesQuery = favoritesQuery.gt(
          'created_at',
          lastSync.toIso8601String(),
        );
      }

      // Query para dislikes
      var dislikesQuery = _supabase
          .from('dislikes')
          .select()
          .eq('user_id', userId);

      if (lastSync != null) {
        dislikesQuery = dislikesQuery.gt(
          'created_at',
          lastSync.toIso8601String(),
        );
      }

      final favoritesResponse = await favoritesQuery;
      final dislikesResponse = await dislikesQuery;

      return {
        'favorites': favoritesResponse as List? ?? [],
        'dislikes': dislikesResponse as List? ?? [],
      };
    } catch (e) {
      print('❌ Erro ao buscar dados de sincronização do swipe: $e');
      return {'favorites': [], 'dislikes': []};
    }
  }
}
