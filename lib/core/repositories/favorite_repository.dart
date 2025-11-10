// core/repositories/favorite_repository.dart
import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../../models/favorite_model.dart';
import 'base_repository.dart';
import 'package:sqflite/sqflite.dart';

class FavoriteRepository extends BaseRepository<FavoriteModel> {
  @override
  String get tableName => 'favorites';

  @override
  FavoriteModel fromMap(Map<String, dynamic> map) => FavoriteModel.fromMap(map);

  @override
  Map<String, dynamic> toMap(FavoriteModel model) => model.toMap();

  // Favoritos do usuário
  Future<List<FavoriteModel>> getUserFavorites(String userId) async {
    return await getWhere('user_id = ?', [userId]);
  }

  // IDs dos lugares favoritos
  Future<List<String>> getFavoritePlaceIds(String userId) async {
    final favorites = await getUserFavorites(userId);
    return favorites.map((f) => f.placeId).toList();
  }

  Future<void> addFavorite(String userId, String placeId) async {
    try {
      final db = await database;

      await db.insert('favorites', {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'user_id': userId,
        'place_id': placeId,
        'created_at': DateTime.now().toIso8601String(),
      }, conflictAlgorithm: ConflictAlgorithm.replace);

      debugPrint('✅ Favorito adicionado: $placeId');
    } catch (e) {
      debugPrint('❌ Erro ao adicionar favorito: $e');
      rethrow;
    }
  }

  // Verificar se é favorito
  Future<bool> isFavorite(String userId, String placeId) async {
    final db = await database;
    final result = await db.query(
      tableName,
      where: 'user_id = ? AND place_id = ?',
      whereArgs: [userId, placeId],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  // Toggle favorito
  Future<bool> toggleFavorite(String userId, String placeId) async {
    try {
      final db = await database;

      // Verificar se já existe
      final existing = await db.query(
        'favorites',
        where: 'user_id = ? AND place_id = ?',
        whereArgs: [userId, placeId],
      );

      if (existing.isNotEmpty) {
        // Remover
        await db.delete(
          'favorites',
          where: 'user_id = ? AND place_id = ?',
          whereArgs: [userId, placeId],
        );
        debugPrint('✅ Favorito removido: $placeId');
        return false;
      } else {
        // Adicionar
        await db.insert('favorites', {
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'user_id': userId,
          'place_id': placeId,
          'created_at': DateTime.now().toIso8601String(),
        });
        debugPrint('✅ Favorito adicionado: $placeId');
        return true;
      }
    } catch (e) {
      debugPrint('❌ Erro ao alternar favorito: $e');
      rethrow;
    }
  }

  // Remover por place_id
  Future<int> removeByPlace(String userId, String placeId) async {
    final db = await database;
    return await db.delete(
      tableName,
      where: 'user_id = ? AND place_id = ?',
      whereArgs: [userId, placeId],
    );
  }

  // Contagem de favoritos
  Future<int> getFavoritesCount(String userId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $tableName WHERE user_id = ?',
      [userId],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }
}
