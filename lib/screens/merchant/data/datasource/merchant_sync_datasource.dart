// data/datasources/merchant/merchant_sync_datasource.dart

import 'package:vivar/models/business_model.dart';
import 'package:vivar/models/merchant_model.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vivar/screens/merchant/data/datasource/merchant_datasource.dart';
import 'package:vivar/screens/merchant/data/datasource/merchant_remote_datasource_impl.dart';

class MerchantSyncDatasource {
  final MerchantLocalDatasourceProtocol _localDatasource;
  final MerchantRemoteDatasourceProtocol _remoteDatasource;
  final Connectivity _connectivity;

  static const String _lastSyncKeyPrefix = 'businesses_last_sync_';
  static const String _hasInitialDataKeyPrefix = 'businesses_has_initial_data_';

  MerchantSyncDatasource({
    required MerchantLocalDatasourceProtocol localDatasource,
    required MerchantRemoteDatasourceProtocol remoteDatasource,
    Connectivity? connectivity,
  }) : _localDatasource = localDatasource,
       _remoteDatasource = remoteDatasource,
       _connectivity = connectivity ?? Connectivity();

  Future<void> registerMerchant(BusinessModel merchant) async {
    await _localDatasource.registerMerchant(merchant);

    if (await _isOnline()) {
      _syncSaveInBackground(merchant);
    }
  }

  Future<BusinessModel?> getMerchantById(String merchantId) async {
    return await _localDatasource.getMerchantById(merchantId);
  }

  Future<List<BusinessModel>> getUserMerchants(String userId) async {
    await _checkAndSync(userId: userId);
    return await _localDatasource.getUserMerchants(userId);
  }

  Future<void> markAsPendingSync(String merchantId) async {
    await _localDatasource.markAsPendingSync(merchantId);
  }

  Future<List<BusinessModel>> getPendingMerchants() async {
    return await _localDatasource.getPendingMerchants();
  }

  Future<void> updateMerchant(BusinessModel merchant) async {
    await _localDatasource.updateMerchant(merchant);

    if (await _isOnline()) {
      _syncUpdateInBackground(merchant);
    }
  }

  Future<void> syncPendingMerchants() async {
    if (!await _isOnline()) return;

    try {
      final pendingMerchants = await _localDatasource.getPendingMerchants();

      for (final merchant in pendingMerchants) {
        try {
          await _remoteDatasource.saveMerchant(merchant);

          final updatedMerchant = merchant.copyWith(synced: true);
          await _localDatasource.updateMerchant(updatedMerchant);
        } catch (e) {
          print('⚠️ Erro ao sincronizar merchant ${merchant.id}: $e');
        }
      }

      print('✅ ${pendingMerchants.length} merchants pendentes sincronizados');
    } catch (e) {
      print('❌ Erro ao sincronizar merchants pendentes: $e');
    }
  }

  Future<void> _checkAndSync({String? userId}) async {
    final hasInitialData = await _hasInitialData(userId);

    if (!hasInitialData && await _isOnline()) {
      await _performInitialSync(userId: userId);
    } else if (await _isOnline() && await _shouldSync(userId)) {
      _syncInBackground(userId: userId);
    }
  }

  Future<void> _performInitialSync({String? userId}) async {
    if (!await _isOnline()) return;

    try {
      print('🔄 Iniciando sincronização inicial de merchants...');
      await _syncMerchants(userId: userId);
      await _markInitialDataLoaded(userId);
      await _updateLastSync(userId);
      print('✅ Sincronização inicial de merchants concluída');
    } catch (e) {
      print('❌ Erro na sincronização inicial de merchants: $e');
    }
  }

  void _syncInBackground({String? userId}) {
    Future.microtask(() async {
      try {
        await _syncMerchants(userId: userId);
        await _updateLastSync(userId);
      } catch (e) {
        print('⚠️ Erro na sincronização em background de merchants: $e');
      }
    });
  }

  void _syncSaveInBackground(BusinessModel merchant) {
    Future.microtask(() async {
      try {
        await _remoteDatasource.saveMerchant(merchant);

        final updatedMerchant = merchant.copyWith(synced: true);
        await _localDatasource.updateMerchant(updatedMerchant);
      } catch (e) {
        print(
          '⚠️ Erro ao sincronizar salvamento de merchant em background: $e',
        );
      }
    });
  }

  void _syncUpdateInBackground(BusinessModel merchant) {
    Future.microtask(() async {
      try {
        await _remoteDatasource.updateMerchant(merchant);
      } catch (e) {
        print(
          '⚠️ Erro ao sincronizar atualização de merchant em background: $e',
        );
      }
    });
  }

  Future<void> _syncMerchants({String? userId}) async {
    if (!await _isOnline()) return;

    try {
      final lastSync = await _getLastSync(userId);
      final syncData = await _remoteDatasource.getSyncData(userId, lastSync);
      final remoteMerchants = (syncData['businesses'] as List)
          .map((data) => BusinessModel.fromMap(data))
          .toList();

      if (remoteMerchants.isEmpty) return;

      for (final merchant in remoteMerchants) {
        final existing = await _localDatasource.getMerchantById(merchant.id);

        if (existing == null) {
          await _localDatasource.registerMerchant(merchant);
        } else {
          if (merchant.updatedAt.isAfter(existing.updatedAt)) {
            await _localDatasource.updateMerchant(merchant);
          }
        }
      }

      print('✅ ${remoteMerchants.length} merchants processados');
    } catch (e) {
      print('❌ Erro ao sincronizar merchants: $e');
    }
  }

  Future<bool> _isOnline() async {
    try {
      final result = await _connectivity.checkConnectivity();
      return result != ConnectivityResult.none;
    } catch (e) {
      print('⚠️ Erro ao verificar conectividade: $e');
      return false;
    }
  }

  Future<bool> _shouldSync(String? userId) async {
    final lastSync = await _getLastSync(userId);
    if (lastSync == null) return true;

    final now = DateTime.now();
    final difference = now.difference(lastSync);

    return difference.inMinutes > 15;
  }

  Future<bool> _hasInitialData(String? userId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = userId != null
        ? '$_hasInitialDataKeyPrefix$userId'
        : _hasInitialDataKeyPrefix;
    return prefs.getBool(key) ?? false;
  }

  Future<void> _markInitialDataLoaded(String? userId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = userId != null
        ? '$_hasInitialDataKeyPrefix$userId'
        : _hasInitialDataKeyPrefix;
    await prefs.setBool(key, true);
  }

  Future<DateTime?> _getLastSync(String? userId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = userId != null
        ? '$_lastSyncKeyPrefix$userId'
        : _lastSyncKeyPrefix;
    final timestamp = prefs.getInt(key);
    return timestamp != null
        ? DateTime.fromMillisecondsSinceEpoch(timestamp)
        : null;
  }

  Future<void> _updateLastSync(String? userId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = userId != null
        ? '$_lastSyncKeyPrefix$userId'
        : _lastSyncKeyPrefix;
    await prefs.setInt(key, DateTime.now().millisecondsSinceEpoch);
  }
}
