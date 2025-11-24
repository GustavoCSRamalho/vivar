// data/datasources/profile/profile_sync_datasource.dart

import 'package:vivar/domain/entity/profile/profile_entity.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vivar/screens/profile/data/datasource/profile/profile_local_datasource.dart';
import 'package:vivar/screens/profile/data/datasource/profile/profile_remote_datasource_impl.dart';

class ProfileSyncDataSource {
  final ProfileLocalDatasourceProtocol _localDatasource;
  final ProfileRemoteDatasourceProtocol _remoteDatasource;
  final Connectivity _connectivity;

  static const String _lastSyncKeyPrefix = 'profile_last_sync_';
  static const String _hasInitialDataKeyPrefix = 'profile_has_initial_data_';

  ProfileSyncDataSource({
    required ProfileLocalDatasourceProtocol localDatasource,
    required ProfileRemoteDatasourceProtocol remoteDatasource,
    Connectivity? connectivity,
  }) : _localDatasource = localDatasource,
       _remoteDatasource = remoteDatasource,
       _connectivity = connectivity ?? Connectivity();

  Future<ProfileEntity?> getProfile(String userId) async {
    await _checkAndSync(userId);
    return await _localDatasource.getProfile(userId);
  }

  Future<void> updateProfile(ProfileEntity profile) async {
    await _localDatasource.updateProfile(profile);

    if (await _isOnline()) {
      _syncUpdateInBackground(profile);
    }
  }

  Future<int> getRecentCheckinsCount(String userId) async {
    await _checkAndSync(userId);
    return await _localDatasource.getRecentCheckinsCount(userId);
  }

  Future<List<String>> getRecentBadges(String userId, {int limit = 5}) async {
    await _checkAndSync(userId);
    return await _localDatasource.getRecentBadges(userId, limit: limit);
  }

  Future<void> _checkAndSync(String userId) async {
    final hasInitialData = await _hasInitialData(userId);

    if (!hasInitialData && await _isOnline()) {
      await _performInitialSync(userId);
    } else if (await _isOnline() && await _shouldSync(userId)) {
      _syncInBackground(userId);
    }
  }

  Future<void> _performInitialSync(String userId) async {
    if (!await _isOnline()) return;

    try {
      print('🔄 Iniciando sincronização inicial do perfil...');
      await _syncProfile(userId);
      await _markInitialDataLoaded(userId);
      await _updateLastSync(userId);
      print('✅ Sincronização inicial do perfil concluída');
    } catch (e) {
      print('❌ Erro na sincronização inicial do perfil: $e');
    }
  }

  void _syncInBackground(String userId) {
    Future.microtask(() async {
      try {
        await _syncProfile(userId);
        await _updateLastSync(userId);
      } catch (e) {
        print('⚠️ Erro na sincronização em background do perfil: $e');
      }
    });
  }

  void _syncUpdateInBackground(ProfileEntity profile) {
    Future.microtask(() async {
      try {
        await _remoteDatasource.updateProfile(profile);
      } catch (e) {
        print('⚠️ Erro ao sincronizar atualização do perfil em background: $e');
      }
    });
  }

  Future<void> _syncProfile(String userId) async {
    if (!await _isOnline()) return;

    try {
      final lastSync = await _getLastSync(userId);
      final remoteProfile = await _remoteDatasource.getProfile(userId);

      if (remoteProfile != null) {
        await _localDatasource.updateProfile(remoteProfile);
      }

      print('✅ Perfil sincronizado');
    } catch (e) {
      print('❌ Erro ao sincronizar perfil: $e');
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

  Future<bool> _shouldSync(String userId) async {
    final lastSync = await _getLastSync(userId);
    if (lastSync == null) return true;

    final now = DateTime.now();
    final difference = now.difference(lastSync);

    return difference.inMinutes > 10;
  }

  Future<bool> _hasInitialData(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('$_hasInitialDataKeyPrefix$userId') ?? false;
  }

  Future<void> _markInitialDataLoaded(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('$_hasInitialDataKeyPrefix$userId', true);
  }

  Future<DateTime?> _getLastSync(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getInt('$_lastSyncKeyPrefix$userId');
    return timestamp != null
        ? DateTime.fromMillisecondsSinceEpoch(timestamp)
        : null;
  }

  Future<void> _updateLastSync(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
      '$_lastSyncKeyPrefix$userId',
      DateTime.now().millisecondsSinceEpoch,
    );
  }
}
