// data/datasources/Businesses/Businesses_sync_datasource.dart

import 'package:vivar/models/business_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vivar/core/database/database_helper.dart';
import 'package:vivar/screens/home/data/datasource/place/home_place_datasource.dart';
import 'package:vivar/screens/home/data/datasource/place/home_place_remote_datasource_impl.dart';

class BusinessesSyncDatasource {
  final BusinessesDatasourceProtocol _localDatasource;
  final BusinessesRemoteDatasourceProtocol _remoteDatasource;
  final Connectivity _connectivity;
  final DatabaseHelper _dbHelper;

  static const String _lastSyncKey = 'businesses_last_sync';
  static const String _hasInitialDataKey = 'businesses_has_initial_data';
  static const String _tableName = 'businesses';

  BusinessesSyncDatasource({
    required BusinessesDatasourceProtocol localDatasource,
    required BusinessesRemoteDatasourceProtocol remoteDatasource,
    Connectivity? connectivity,
    DatabaseHelper? dbHelper,
  }) : _localDatasource = localDatasource,
       _remoteDatasource = remoteDatasource,
       _connectivity = connectivity ?? Connectivity(),
       _dbHelper = dbHelper ?? DatabaseHelper();

  Future<List<BusinessModel>> getAllBusinessess() async {
    await _checkAndSync();
    return await _localDatasource.getAllBusinesses();
  }

  Future<List<BusinessModel>> getNearbyBusinessess({
    required double latitude,
    required double longitude,
    required double radiusKm,
  }) async {
    await _checkAndSync();
    return await _localDatasource.getNearbyBusinesses(
      latitude: latitude,
      longitude: longitude,
      radiusKm: radiusKm,
    );
  }

  Future<List<BusinessModel>> getBusinessessByCategory(String category) async {
    await _checkAndSync();
    return await _localDatasource.getBusinessesByCategory(category);
  }

  Future<List<BusinessModel>> searchBusinessess(String query) async {
    await _checkAndSync();
    return await _localDatasource.searchBusinesses(query);
  }

  Future<BusinessModel?> getBusinessesById(String id) async {
    await _checkAndSync();
    return await _localDatasource.getBusinessesById(id);
  }

  Future<List<BusinessModel>> getBusinessessWithDiscount() async {
    await _checkAndSync();
    return await _localDatasource.getBusinessesWithDiscount();
  }

  Future<List<BusinessModel>> getTopRatedBusinessess({int limit = 10}) async {
    await _checkAndSync();
    return await _localDatasource.getTopRatedBusinesses(limit: limit);
  }

  Future<List<BusinessModel>> getFilteredBusinessess({
    List<String>? categories,
    String? priceRange,
    double? minRating,
    List<String>? amenities,
    bool? openNow,
  }) async {
    await _checkAndSync();
    return await _localDatasource.getFilteredBusinesses(
      categories: categories,
      priceRange: priceRange,
      minRating: minRating,
      amenities: amenities,
      openNow: openNow,
    );
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
      print('🔄 Iniciando sincronização inicial de lugares...');
      await _syncBusinessess();
      await _markInitialDataLoaded();
      await _updateLastSync();
      print('✅ Sincronização inicial concluída');
    } catch (e) {
      print('❌ Erro na sincronização inicial: $e');
    }
  }

  void _syncInBackground() {
    Future.microtask(() async {
      try {
        await _syncBusinessess();
        await _updateLastSync();
      } catch (e) {
        print('⚠️ Erro na sincronização em background: $e');
      }
    });
  }

  Future<void> _syncBusinessess() async {
    if (!await _isOnline()) return;

    try {
      final lastSync = await _getLastSync();
      final syncData = await _remoteDatasource.getSyncData(lastSync);
      final remoteBusinessess = (syncData['businesses'] as List)
          .map((data) => BusinessModel.fromMap(data))
          .toList();

      if (remoteBusinessess.isEmpty) return;

      final db = await _dbHelper.database;
      final batch = db.batch();

      for (final Businesses in remoteBusinessess) {
        final existing = await _localDatasource.getBusinessesById(
          Businesses.id,
        );

        if (existing == null) {
          batch.insert(
            _tableName,
            Businesses.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        } else {
          if (Businesses.updatedAt.isAfter(existing.updatedAt)) {
            batch.update(
              _tableName,
              Businesses.toMap(),
              where: 'id = ?',
              whereArgs: [Businesses.id],
            );
          }
        }
      }

      await batch.commit(noResult: true);
      print('✅ ${remoteBusinessess.length} lugares processados');
    } catch (e) {
      print('❌ Erro ao sincronizar lugares: $e');
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
