// data/datasources/place/place_details_sync_datasource.dart

import 'package:vivar/models/business_model.dart';
import 'package:vivar/models/place_model.dart';
import 'package:vivar/models/review_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vivar/core/database/database_helper.dart';
import 'package:vivar/screens/place_details/data/datasource/place_details_datasource.dart';
import 'package:vivar/screens/place_details/data/datasource/place_details_remote_datasource_impl.dart';

class PlaceDetailsSyncDatasource {
  final PlaceDetailsDatasourceProtocol _localDatasource;
  final PlaceDetailsRemoteDatasourceProtocol _remoteDatasource;
  final Connectivity _connectivity;
  final DatabaseHelper _dbHelper;

  static const String _lastSyncKeyPrefix = 'place_details_last_sync_';
  static const String _hasInitialDataKeyPrefix =
      'place_details_has_initial_data_';
  static const String _placeTableName = 'businesses';
  static const String _reviewTableName = 'reviews';

  PlaceDetailsSyncDatasource({
    required PlaceDetailsDatasourceProtocol localDatasource,
    required PlaceDetailsRemoteDatasourceProtocol remoteDatasource,
    Connectivity? connectivity,
    DatabaseHelper? dbHelper,
  }) : _localDatasource = localDatasource,
       _remoteDatasource = remoteDatasource,
       _connectivity = connectivity ?? Connectivity(),
       _dbHelper = dbHelper ?? DatabaseHelper();

  Future<BusinessModel?> getPlaceById(String placeId) async {
    await _checkAndSync(placeId);
    return await _localDatasource.getPlaceById(placeId);
  }

  Future<List<Map<String, dynamic>>> getPlaceReviews(String placeId) async {
    await _checkAndSync(placeId);
    return await _localDatasource.getPlaceReviews(placeId);
  }

  Future<void> addReview(ReviewModel review) async {
    await _localDatasource.addReview(review);

    if (await _isOnline()) {
      _syncReviewInBackground(review);
    }
  }

  Future<bool> checkIfUserReviewed(String userId, String placeId) async {
    return await _localDatasource.checkIfUserReviewed(userId, placeId);
  }

  Future<void> _checkAndSync(String placeId) async {
    final hasInitialData = await _hasInitialData(placeId);

    if (!hasInitialData && await _isOnline()) {
      await _performInitialSync(placeId);
    } else if (await _isOnline() && await _shouldSync(placeId)) {
      _syncInBackground(placeId);
    }
  }

  Future<void> _performInitialSync(String placeId) async {
    if (!await _isOnline()) return;

    try {
      print(
        '🔄 Iniciando sincronização inicial de detalhes do lugar $placeId...',
      );
      await _syncPlaceDetails(placeId);
      await _markInitialDataLoaded(placeId);
      await _updateLastSync(placeId);
      print('✅ Sincronização inicial de detalhes concluída');
    } catch (e) {
      print('❌ Erro na sincronização inicial de detalhes: $e');
    }
  }

  void _syncInBackground(String placeId) {
    Future.microtask(() async {
      try {
        await _syncPlaceDetails(placeId);
        await _updateLastSync(placeId);
      } catch (e) {
        print('⚠️ Erro na sincronização em background de detalhes: $e');
      }
    });
  }

  void _syncReviewInBackground(ReviewModel review) {
    Future.microtask(() async {
      try {
        await _remoteDatasource.addReview(review);
      } catch (e) {
        print('⚠️ Erro ao sincronizar review em background: $e');
      }
    });
  }

  Future<void> _syncPlaceDetails(String placeId) async {
    if (!await _isOnline()) return;

    try {
      final lastSync = await _getLastSync(placeId);
      final syncData = await _remoteDatasource.getSyncData(placeId, lastSync);

      final db = await _dbHelper.database;
      final batch = db.batch();

      if (syncData['place'] != null) {
        final remotePlace = BusinessModel.fromMap(syncData['place']);
        final localPlace = await _localDatasource.getPlaceById(placeId);

        if (localPlace == null ||
            remotePlace.updatedAt.isAfter(localPlace.updatedAt)) {
          batch.update(
            _placeTableName,
            remotePlace.toMap(),
            where: 'id = ?',
            whereArgs: [placeId],
          );
        }
      }

      final remoteReviews = (syncData['reviews'] as List);
      for (final reviewData in remoteReviews) {
        final review = ReviewModel.fromMap(reviewData);
        batch.insert(
          _reviewTableName,
          review.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      await batch.commit(noResult: true);
      print('✅ Detalhes: ${remoteReviews.length} reviews processadas');
    } catch (e) {
      print('❌ Erro ao sincronizar detalhes do lugar: $e');
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

  Future<bool> _shouldSync(String placeId) async {
    final lastSync = await _getLastSync(placeId);
    if (lastSync == null) return true;

    final now = DateTime.now();
    final difference = now.difference(lastSync);

    return difference.inMinutes > 10;
  }

  Future<bool> _hasInitialData(String placeId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('$_hasInitialDataKeyPrefix$placeId') ?? false;
  }

  Future<void> _markInitialDataLoaded(String placeId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('$_hasInitialDataKeyPrefix$placeId', true);
  }

  Future<DateTime?> _getLastSync(String placeId) async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getInt('$_lastSyncKeyPrefix$placeId');
    return timestamp != null
        ? DateTime.fromMillisecondsSinceEpoch(timestamp)
        : null;
  }

  Future<void> _updateLastSync(String placeId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
      '$_lastSyncKeyPrefix$placeId',
      DateTime.now().millisecondsSinceEpoch,
    );
  }
}
