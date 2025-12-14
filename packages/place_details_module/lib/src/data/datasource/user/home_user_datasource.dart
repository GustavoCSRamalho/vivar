// data/datasources/user/user_datasource_impl.dart
// data/datasources/user/user_datasource_protocol.dart
import 'package:core_module/core_module.dart';
import 'package:place_details_module/src/data/models/user_model.dart';
import 'package:sqflite/sqflite.dart';

/// Contrato abstrato para datasource de usuário
/// Define os métodos que devem ser implementados para gerenciar dados de usuários
abstract class UserDatasourceProtocol {
  /// Busca o usuário atual (primeiro usuário da tabela)
  ///
  /// Retorna [UserModel] se encontrado, ou [null] caso contrário
  Future<UserModel?> getCurrentUser();

  /// Busca um usuário específico pelo ID
  ///
  /// Retorna [UserModel] se encontrado, ou [null] caso contrário
  Future<UserModel?> getUserById(String id);

  /// Atualiza os dados de um usuário
  ///
  /// [user] - Modelo do usuário com os dados atualizados
  Future<void> updateUser(UserModel user);

  /// Busca os IDs dos lugares favoritos de um usuário
  ///
  /// [userId] - ID do usuário
  /// Retorna lista de IDs dos lugares favoritos
  Future<List<String>> getUserFavoritePlaceIds(String userId);

  /// Adiciona um lugar aos favoritos do usuário
  ///
  /// [userId] - ID do usuário
  /// [placeId] - ID do lugar a ser favoritado
  Future<void> addFavorite(String userId, String placeId);

  /// Remove um lugar dos favoritos do usuário
  ///
  /// [userId] - ID do usuário
  /// [placeId] - ID do lugar a ser removido dos favoritos
  Future<void> removeFavorite(String userId, String placeId);

  /// Alterna o estado de favorito de um lugar
  ///
  /// [userId] - ID do usuário
  /// [placeId] - ID do lugar
  /// Retorna [true] se foi adicionado aos favoritos, [false] se foi removido
  Future<bool> toggleFavorite(String userId, String placeId);
}

/// Implementação do datasource de usuário
/// Contém TODA a lógica de acesso ao banco de dados SQLite
/// Gerencia as tabelas 'users' e 'favorites'
class UserDatasourceImpl implements UserDatasourceProtocol {
  final DatabaseHelper _dbHelper;

  static const String _userTableName = 'users';
  static const String _favoriteTableName = 'favorites';

  UserDatasourceImpl({DatabaseHelper? dbHelper})
    : _dbHelper = dbHelper ?? DatabaseHelper();

  Future<Database> get _database async => await _dbHelper.database;

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final db = await _database;
      final List<Map<String, dynamic>> maps = await db.query(
        _userTableName,
        limit: 1,
      );

      if (maps.isEmpty) return null;

      return UserModel.fromMap(maps.first);
    } catch (e) {
      print('❌ Erro ao buscar usuário atual: $e');
      return null;
    }
  }

  @override
  Future<UserModel?> getUserById(String id) async {
    try {
      final db = await _database;
      final List<Map<String, dynamic>> maps = await db.query(
        _userTableName,
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (maps.isEmpty) return null;

      return UserModel.fromMap(maps.first);
    } catch (e) {
      print('❌ Erro ao buscar usuário por ID: $e');
      return null;
    }
  }

  @override
  Future<void> updateUser(UserModel user) async {
    try {
      final db = await _database;
      await db.update(
        _userTableName,
        user.toMap(),
        where: 'id = ?',
        whereArgs: [user.id],
      );
    } catch (e) {
      print('❌ Erro ao atualizar usuário: $e');
      rethrow;
    }
  }

  @override
  Future<List<String>> getUserFavoritePlaceIds(String userId) async {
    try {
      final db = await _database;
      final List<Map<String, dynamic>> maps = await db.query(
        _favoriteTableName,
        where: 'user_id = ?',
        whereArgs: [userId],
      );

      return maps.map((m) => m['place_id'] as String).toList();
    } catch (e) {
      print('❌ Erro ao buscar favoritos do usuário: $e');
      return [];
    }
  }

  @override
  Future<void> addFavorite(String userId, String placeId) async {
    try {
      final db = await _database;
      await db.insert(_favoriteTableName, {
        'id': _generateFavoriteId(),
        'user_id': userId,
        'place_id': placeId,
        'created_at': DateTime.now().toIso8601String(),
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      print('❌ Erro ao adicionar favorito: $e');
      rethrow;
    }
  }

  @override
  Future<void> removeFavorite(String userId, String placeId) async {
    try {
      final db = await _database;
      await db.delete(
        _favoriteTableName,
        where: 'user_id = ? AND place_id = ?',
        whereArgs: [userId, placeId],
      );
    } catch (e) {
      print('❌ Erro ao remover favorito: $e');
      rethrow;
    }
  }

  @override
  Future<bool> toggleFavorite(String userId, String placeId) async {
    try {
      final db = await _database;

      final existing = await db.query(
        _favoriteTableName,
        where: 'user_id = ? AND place_id = ?',
        whereArgs: [userId, placeId],
      );

      if (existing.isNotEmpty) {
        // Remove o favorito
        await db.delete(
          _favoriteTableName,
          where: 'user_id = ? AND place_id = ?',
          whereArgs: [userId, placeId],
        );
        return false; // Removido
      } else {
        // Adiciona o favorito
        await db.insert(_favoriteTableName, {
          'id': _generateFavoriteId(),
          'user_id': userId,
          'place_id': placeId,
          'created_at': DateTime.now().toIso8601String(),
        });
        return true; // Adicionado
      }
    } catch (e) {
      print('❌ Erro ao alternar favorito: $e');
      rethrow;
    }
  }

  /// Gera um ID único para o favorito baseado no timestamp
  String _generateFavoriteId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}
