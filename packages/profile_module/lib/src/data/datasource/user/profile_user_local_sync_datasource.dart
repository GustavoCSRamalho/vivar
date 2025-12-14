// data/datasources/user/user_local_sync_datasource.dart

import 'package:profile_module/src/data/models/user_model.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'profile_user_local_datasource.dart';

import 'profile_user_local_remote_datasource_impl.dart';

abstract class UserSyncDataSourceProtocol {
  Future<UserModel?> getUser(String userId);
  Future<void> updateUser(Map<String, dynamic> data, String userId);
  Future<void> updateAvatar(String userId, String url);
  Future<void> removeAvatar(String userId);
}

class UserLocalSyncDataSource implements UserSyncDataSourceProtocol {
  final UserLocalDataSourceProtocol _localDatasource;
  final UserLocalRemoteDatasourceProtocol _remoteDatasource;
  final Connectivity _connectivity;

  UserLocalSyncDataSource({
    required UserLocalDataSourceProtocol localDatasource,
    required UserLocalRemoteDatasourceProtocol remoteDatasource,
    Connectivity? connectivity,
  }) : _localDatasource = localDatasource,
       _remoteDatasource = remoteDatasource,
       _connectivity = connectivity ?? Connectivity();

  @override
  Future<UserModel?> getUser(String userId) async {
    return await _localDatasource.getUser(userId);
  }

  @override
  Future<void> updateUser(Map<String, dynamic> data, String userId) async {
    final updateData = {
      ...data,
      'updated_at': DateTime.now().toIso8601String(),
    };

    await _localDatasource.updateUser(updateData, userId);

    if (await _isOnline()) {
      _syncUpdateInBackground(data, userId);
    }
  }

  @override
  Future<void> updateAvatar(String userId, String url) async {
    await _localDatasource.updateAvatar(userId, url);

    if (await _isOnline()) {
      _syncAvatarUpdateInBackground(userId, url);
    }
  }

  @override
  Future<void> removeAvatar(String userId) async {
    await _localDatasource.removeAvatar(userId);

    if (await _isOnline()) {
      _syncAvatarRemovalInBackground(userId);
    }
  }

  void _syncUpdateInBackground(Map<String, dynamic> data, String userId) {
    Future.microtask(() async {
      try {
        await _remoteDatasource.updateUser(data, userId);
      } catch (e) {
        print(
          '⚠️ Erro ao sincronizar atualização de usuário em background: $e',
        );
      }
    });
  }

  void _syncAvatarUpdateInBackground(String userId, String url) {
    Future.microtask(() async {
      try {
        await _remoteDatasource.updateAvatar(userId, url);
      } catch (e) {
        print('⚠️ Erro ao sincronizar avatar em background: $e');
      }
    });
  }

  void _syncAvatarRemovalInBackground(String userId) {
    Future.microtask(() async {
      try {
        await _remoteDatasource.removeAvatar(userId);
      } catch (e) {
        print('⚠️ Erro ao sincronizar remoção de avatar em background: $e');
      }
    });
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
}
