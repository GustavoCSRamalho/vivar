// data/datasources/map/map_sync_datasource.dart

import 'package:vivar/models/business_model.dart';
import 'package:vivar/models/place_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vivar/core/database/database_helper.dart';
import 'package:vivar/screens/map/data/datasource/map_datasource.dart';
import 'package:vivar/screens/map/data/datasource/map_remote_datasource_impl.dart';

class MapSyncDatasource {
  final MapDatasourceProtocol _localDatasource;
  final MapRemoteDatasourceProtocol _remoteDatasource;
  final Connectivity _connectivity;
  final DatabaseHelper _dbHelper;

  static const String _lastSyncKey = 'map_last_sync';
  static const String _hasInitialDataKey = 'map_has_initial_data';
  static const String _tableName = 'businesses';

  MapSyncDatasource({
    required MapDatasourceProtocol localDatasource,
    required MapRemoteDatasourceProtocol remoteDatasource,
    Connectivity? connectivity,
    DatabaseHelper? dbHelper,
  }) : _localDatasource = localDatasource,
       _remoteDatasource = remoteDatasource,
       _connectivity = connectivity ?? Connectivity(),
       _dbHelper = dbHelper ?? DatabaseHelper();

  Future<List<BusinessModel>> getBusinessesForMap() async {
    await _checkAndSync();
    return await _localDatasource.getBusinessesForMap();
  }

  Future<List<BusinessModel>> getBusinessesByCategory(String category) async {
    await _checkAndSync();
    return await _localDatasource.getBusinessesByCategory(category);
  }

  Future<List<BusinessModel>> getNearbyBusinessesForMap({
    required double latitude,
    required double longitude,
    required double radiusKm,
  }) async {
    await _checkAndSync();
    return await _localDatasource.getNearbyBusinessesForMap(
      latitude: latitude,
      longitude: longitude,
      radiusKm: radiusKm,
    );
  }

  Future<List<BusinessModel>> searchBusinessesOnMap(String query) async {
    await _checkAndSync();
    return await _localDatasource.searchBusinessesOnMap(query);
  }

  Future<void> _checkAndSync() async {
    final hasInitialData = await _hasInitialData();

    if (!hasInitialData && await _isOnline()) {
      await _performInitialSync();
    } else if (await _isOnline() && await _shouldSync()) {
      _syncInBackground();
    }
  }

  Future<void> _performInitialSync() async {
    if (!await _isOnline()) return;

    try {
      print('🔄 Iniciando sincronização inicial do mapa...');
      await _syncBusinesses();
      await _markInitialDataLoaded();
      await _updateLastSync();
      print('✅ Sincronização inicial do mapa concluída');
    } catch (e) {
      print('❌ Erro na sincronização inicial do mapa: $e');
    }
  }

  void _syncInBackground() {
    Future.microtask(() async {
      try {
        await _syncBusinesses();
        await _updateLastSync();
      } catch (e) {
        print('⚠️ Erro na sincronização em background do mapa: $e');
      }
    });
  }

  Future<void> _syncBusinesses() async {
    if (!await _isOnline()) return;

    try {
      final lastSync = await _getLastSync();
      final syncData = await _remoteDatasource.getSyncData(lastSync);
      final remoteBusinesses = (syncData['businesses'] as List)
          .map((data) => BusinessModel.fromMap(data))
          .toList();

      if (remoteBusinesses.isEmpty) return;

      final db = await _dbHelper.database;
      final batch = db.batch();

      for (final place in remoteBusinesses) {
        final existingData = await db.query(
          _tableName,
          where: 'id = ?',
          whereArgs: [place.id],
          limit: 1,
        );

        if (existingData.isEmpty) {
          batch.insert(
            _tableName,
            place.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        } else {
          final existing = BusinessModel.fromMap(existingData.first);
          if (place.updatedAt.isAfter(existing.updatedAt)) {
            batch.update(
              _tableName,
              place.toMap(),
              where: 'id = ?',
              whereArgs: [place.id],
            );
          }
        }
      }

      await batch.commit(noResult: true);
      print('✅ Mapa: ${remoteBusinesses.length} lugares processados');
    } catch (e) {
      print('❌ Erro ao sincronizar lugares do mapa: $e');
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

    return difference.inMinutes > 15;
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
