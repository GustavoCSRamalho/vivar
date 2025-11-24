// data/datasources/merchant/merchant_remote_datasource_protocol.dart

import 'package:vivar/models/business_model.dart';
import 'package:vivar/models/merchant_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class MerchantRemoteDatasourceProtocol {
  Future<void> saveMerchant(BusinessModel merchant);
  Future<BusinessModel?> getMerchantById(String merchantId);
  Future<List<BusinessModel>> getUserMerchants(String userId);
  Future<void> updateMerchant(BusinessModel merchant);
  Future<void> deleteMerchant(String merchantId);
  Future<Map<String, dynamic>> getSyncData(String? userId, DateTime? lastSync);
}

// data/datasources/merchant/merchant_remote_datasource_impl.dart

class MerchantRemoteDatasourceImpl implements MerchantRemoteDatasourceProtocol {
  final SupabaseClient _supabase;
  static const String _tableName = 'businesses';

  MerchantRemoteDatasourceImpl({SupabaseClient? supabase})
    : _supabase = supabase ?? Supabase.instance.client;

  @override
  Future<void> saveMerchant(BusinessModel merchant) async {
    try {
      final data = {
        ...merchant.toMap(),
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      await _supabase.from(_tableName).insert(data);
    } catch (e) {
      print('❌ Erro ao salvar comerciante na nuvem: $e');
      rethrow;
    }
  }

  @override
  Future<BusinessModel?> getMerchantById(String merchantId) async {
    try {
      final response = await _supabase
          .from(_tableName)
          .select()
          .eq('id', merchantId)
          .maybeSingle();

      if (response == null) return null;
      return BusinessModel.fromMap(response);
    } catch (e) {
      print('❌ Erro ao buscar comerciante por ID na nuvem: $e');
      return null;
    }
  }

  @override
  Future<List<BusinessModel>> getUserMerchants(String userId) async {
    try {
      final response = await _supabase
          .from(_tableName)
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((data) => BusinessModel.fromMap(data))
          .toList();
    } catch (e) {
      print('❌ Erro ao buscar comerciantes do usuário na nuvem: $e');
      return [];
    }
  }

  @override
  Future<void> updateMerchant(BusinessModel merchant) async {
    try {
      final data = {
        ...merchant.toMap(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      await _supabase.from(_tableName).update(data).eq('id', merchant.id);
    } catch (e) {
      print('❌ Erro ao atualizar comerciante na nuvem: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteMerchant(String merchantId) async {
    try {
      await _supabase.from(_tableName).delete().eq('id', merchantId);
    } catch (e) {
      print('❌ Erro ao deletar comerciante da nuvem: $e');
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> getSyncData(
    String? userId,
    DateTime? lastSync,
  ) async {
    try {
      var query = _supabase.from(_tableName).select();

      if (userId != null) {
        query = query.eq('user_id', userId);
      }

      if (lastSync != null) {
        query = query.gt('updated_at', lastSync.toIso8601String());
      }

      final response = await query;
      final businesses = response as List;

      return {'businesses': businesses, 'total': businesses.length};
    } catch (e) {
      print('❌ Erro ao buscar dados de sincronização de merchants: $e');
      return {'businesses': [], 'total': 0};
    }
  }
}
