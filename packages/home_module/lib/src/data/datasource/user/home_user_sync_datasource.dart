// data/datasources/user/user_sync_datasource.dart

import 'package:home_module/src/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'home_user_datasource.dart';
import 'home_user_remote_datasource_impl.dart';

class UserSyncDatasource {
  final UserDatasourceProtocol _localDatasource;
  final UserRemoteDatasourceProtocol _remoteDatasource;
  final Connectivity _connectivity;

  static const String _lastSyncKey = 'user_last_sync';
  static const String _hasInitialDataKey = 'user_has_initial_data';

  UserSyncDatasource({
    required UserDatasourceProtocol localDatasource,
    required UserRemoteDatasourceProtocol remoteDatasource,
    Connectivity? connectivity,
  }) : _localDatasource = localDatasource,
       _remoteDatasource = remoteDatasource,
       _connectivity = connectivity ?? Connectivity();

  Future<UserModel?> getCurrentUser({bool forceSync = false}) async {
    final hasInitialData = await _hasInitialData();

    if (!hasInitialData && await _isOnline()) {
      await _performInitialSync();
    } else if (await _isOnline() && await _shouldSync()) {
      _syncInBackground();
    }

    return await _localDatasource.getCurrentUser();
  }

  Future<UserModel?> getUserById(String id) async {
    final hasInitialData = await _hasInitialData();

    if (!hasInitialData && await _isOnline()) {
      await _performInitialSync();
    } else if (await _isOnline() && await _shouldSync()) {
      _syncInBackground();
    }

    return await _localDatasource.getUserById(id);
  }

  Future<void> updateUser(UserModel user) async {
    await _localDatasource.updateUser(user);

    if (await _isOnline()) {
      _syncInBackground();
    }
  }

  Future<List<String>> getUserFavoritePlaceIds(String userId) async {
    final hasInitialData = await _hasInitialData();

    if (!hasInitialData && await _isOnline()) {
      await _performInitialSync();
    } else if (await _isOnline() && await _shouldSync()) {
      _syncInBackground();
    }

    return await _localDatasource.getUserFavoritePlaceIds(userId);
  }

  Future<void> addFavorite(String userId, String placeId) async {
    await _localDatasource.addFavorite(userId, placeId);

    if (await _isOnline()) {
      _syncInBackground();
    }
  }

  Future<void> removeFavorite(String userId, String placeId) async {
    await _localDatasource.removeFavorite(userId, placeId);

    if (await _isOnline()) {
      _syncInBackground();
    }
  }

  Future<bool> toggleFavorite(String userId, String placeId) async {
    final result = await _localDatasource.toggleFavorite(userId, placeId);

    if (await _isOnline()) {
      _syncInBackground();
    }

    return result;
  }

  Future<void> _performInitialSync() async {
    try {
      final localUser = await _localDatasource.getCurrentUser();
      if (localUser != null) {
        await _syncUser(localUser.id);
        await _syncFavorites(localUser.id);
        await _markInitialDataLoaded();
        await _updateLastSync();
      }
    } catch (e) {
      print('❌ Erro na sincronização inicial: $e');
    }
  }

  void _syncInBackground() {
    Future.microtask(() async {
      try {
        final localUser = await _localDatasource.getCurrentUser();
        if (localUser != null) {
          await _syncUser(localUser.id);
          await _syncFavorites(localUser.id);
          await _updateLastSync();
        }
      } catch (e) {
        print('⚠️ Erro na sincronização em background: $e');
      }
    });
  }

  Future<void> _syncUser(String? userId) async {
    if (userId == null || !await _isOnline()) return;

    try {
      final lastSync = await _getLastSync();
      final syncData = await _remoteDatasource.getSyncData(userId, lastSync);

      if (syncData['user'] != null) {
        final remoteUser = UserModel.fromMap(syncData['user']);
        final localUser = await _localDatasource.getUserById(userId);

        if (localUser == null ||
            remoteUser.updatedAt.isAfter(localUser.updatedAt)) {
          await _localDatasource.updateUser(remoteUser);
        }
      }
    } catch (e) {
      print('❌ Erro ao sincronizar usuário: $e');
    }
  }

  Future<void> _syncFavorites(String userId) async {
    if (!await _isOnline()) return;

    try {
      final lastSync = await _getLastSync();
      final syncData = await _remoteDatasource.getSyncData(userId, lastSync);

      final remoteFavorites = (syncData['favorites'] as List)
          .map((f) => f['place_id'] as String)
          .toSet();
      final localFavorites = (await _localDatasource.getUserFavoritePlaceIds(
        userId,
      )).toSet();

      final toAdd = remoteFavorites.difference(localFavorites);
      final toRemove = localFavorites.difference(remoteFavorites);

      for (final placeId in toAdd) {
        await _localDatasource.addFavorite(userId, placeId);
      }

      for (final placeId in toRemove) {
        await _localDatasource.removeFavorite(userId, placeId);
      }
    } catch (e) {
      print('❌ Erro ao sincronizar favoritos: $e');
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

  Future<bool> _shouldSync() async {
    final lastSync = await _getLastSync();
    if (lastSync == null) return true;

    final now = DateTime.now();
    final difference = now.difference(lastSync);

    return difference.inMinutes > 5;
  }

  Future<bool> _hasInitialData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_hasInitialDataKey) ?? false;
  }

  Future<void> _markInitialDataLoaded() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasInitialDataKey, true);
  }

  Future<DateTime?> _getLastSync() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getInt(_lastSyncKey);
    return timestamp != null
        ? DateTime.fromMillisecondsSinceEpoch(timestamp)
        : null;
  }

  Future<void> _updateLastSync() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastSyncKey, DateTime.now().millisecondsSinceEpoch);
  }
}
