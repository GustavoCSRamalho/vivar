// data/services/swipe/swipe_sync_service.dart

import 'package:vivar/models/business_model.dart';
import 'package:vivar/models/place_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vivar/core/database/database_helper.dart';
import 'package:vivar/screens/swipe/data/datasource/swipe_local_datasource.dart';
import 'package:vivar/screens/swipe/data/datasource/swipe_remote_datasource_impl.dart';

class SwipeSyncService {
  final SwipeLocalDataSourceProtocol _localDataSource;
  final SwipeRemoteDatasourceProtocol _remoteDataSource;
  final DatabaseHelper _dbHelper = DatabaseHelper();

  SwipeSyncService({
    required SwipeLocalDataSourceProtocol localDataSource,
    required SwipeRemoteDatasourceProtocol remoteDataSource,
  }) : _localDataSource = localDataSource,
       _remoteDataSource = remoteDataSource;

  Future<Database> get _database async => await _dbHelper.database;

  // ========== Métodos delegados para os datasources ==========

  Future<List<BusinessModel>> getSwipePlaces() async {
    return await _localDataSource.getSwipePlaces();
  }

  Future<List<BusinessModel>> getSwipePlacesRemote({int limit = 50}) async {
    return await _remoteDataSource.getSwipePlaces(limit: limit);
  }

  Future<void> likePlace(String userId, String placeId) async {
    return await _localDataSource.likePlace(userId, placeId);
  }

  Future<void> superLikePlace(String userId, String placeId) async {
    return await _localDataSource.superLikePlace(userId, placeId);
  }

  Future<void> dislikePlace(String userId, String placeId) async {
    return await _localDataSource.dislikePlace(userId, placeId);
  }

  // ========== Métodos de sincronização ==========

  /// Sincroniza favoritos do servidor para o local
  Future<void> syncFromRemote(String userId) async {
    try {
      print('🔄 Iniciando sincronização de swipe do servidor...');

      final db = await _database;

      // Busca última sincronização
      final lastSyncResult = await db.query(
        'sync_metadata',
        where: 'entity_type = ?',
        whereArgs: ['swipe'],
        limit: 1,
      );

      DateTime? lastSync;
      if (lastSyncResult.isNotEmpty) {
        final lastSyncStr = lastSyncResult.first['last_sync'] as String?;
        if (lastSyncStr != null) {
          lastSync = DateTime.parse(lastSyncStr);
        }
      }

      // Busca dados atualizados do servidor
      final syncData = await _remoteDataSource.getSyncData(userId, lastSync);
      final favorites = syncData['favorites'] as List;
      final dislikes = syncData['dislikes'] as List;

      print(
        '📥 Recebidos ${favorites.length} favoritos e ${dislikes.length} dislikes',
      );

      // Salva favoritos localmente usando o datasource local
      for (final favorite in favorites) {
        final isSuperLike = favorite['is_super_like'] == true;
        final placeId = favorite['place_id'] as String;

        if (isSuperLike) {
          await _localDataSource.superLikePlace(userId, placeId);
        } else {
          await _localDataSource.likePlace(userId, placeId);
        }

        // Marca como já sincronizado no banco
        await db.update(
          'favorites',
          {'synced': 1},
          where: 'place_id = ? AND user_id = ?',
          whereArgs: [placeId, userId],
        );
      }

      // Salva dislikes localmente usando o datasource local
      for (final dislike in dislikes) {
        final placeId = dislike['place_id'] as String;
        await _localDataSource.dislikePlace(userId, placeId);

        // Marca como já sincronizado
        await db.update(
          'dislikes',
          {'synced': 1},
          where: 'place_id = ? AND user_id = ?',
          whereArgs: [placeId, userId],
        );
      }

      // Atualiza timestamp da sincronização
      await db.insert('sync_metadata', {
        'entity_type': 'swipe',
        'last_sync': DateTime.now().toIso8601String(),
      }, conflictAlgorithm: ConflictAlgorithm.replace);

      print('✅ Sincronização de swipe concluída');
    } catch (e) {
      print('❌ Erro ao sincronizar swipe do servidor: $e');
      rethrow;
    }
  }

  /// Sincroniza favoritos pendentes do local para o servidor
  Future<void> syncToRemote(String userId) async {
    try {
      print('🔄 Iniciando envio de swipes para o servidor...');

      final db = await _database;

      // Busca favoritos não sincronizados
      final pendingFavorites = await db.query(
        'favorites',
        where: 'user_id = ? AND synced = ?',
        whereArgs: [userId, 0],
      );

      print('📤 Enviando ${pendingFavorites.length} favoritos pendentes');

      for (final favorite in pendingFavorites) {
        try {
          final isSuperLike = (favorite['is_super_like'] as int?) == 1;
          final placeId = favorite['place_id'] as String;

          // Usa o remote datasource para enviar
          if (isSuperLike) {
            await _remoteDataSource.superLikePlace(userId, placeId);
          } else {
            await _remoteDataSource.likePlace(userId, placeId);
          }

          // Marca como sincronizado
          await db.update(
            'favorites',
            {'synced': 1},
            where: 'id = ?',
            whereArgs: [favorite['id']],
          );
        } catch (e) {
          print('❌ Erro ao sincronizar favorito ${favorite['id']}: $e');
          // Continua com os próximos mesmo se um falhar
        }
      }

      // Busca dislikes não sincronizados (se existirem)
      final pendingDislikes = await db.query(
        'dislikes',
        where: 'user_id = ? AND synced = ?',
        whereArgs: [userId, 0],
      );

      print('📤 Enviando ${pendingDislikes.length} dislikes pendentes');

      for (final dislike in pendingDislikes) {
        try {
          final placeId = dislike['place_id'] as String;

          // Usa o remote datasource para enviar
          await _remoteDataSource.dislikePlace(userId, placeId);

          // Marca como sincronizado
          await db.update(
            'dislikes',
            {'synced': 1},
            where: 'id = ?',
            whereArgs: [dislike['id']],
          );
        } catch (e) {
          print('❌ Erro ao sincronizar dislike ${dislike['id']}: $e');
        }
      }

      print('✅ Envio de swipes concluído');
    } catch (e) {
      print('❌ Erro ao enviar swipes para o servidor: $e');
      rethrow;
    }
  }

  /// Sincronização bidirecional completa
  Future<void> fullSync(String userId) async {
    try {
      print('🔄 Iniciando sincronização completa de swipe...');

      // Primeiro envia dados locais para o servidor
      await syncToRemote(userId);

      // Depois busca dados atualizados do servidor
      await syncFromRemote(userId);

      print('✅ Sincronização completa de swipe finalizada');
    } catch (e) {
      print('❌ Erro na sincronização completa de swipe: $e');
      rethrow;
    }
  }
}
