// data/datasources/auth/auth_datasource.dart

import 'package:core_module/core_module.dart';
import 'package:sqflite/sqflite.dart';
import '../model/auth_user_model.dart';

/// Contrato abstrato para datasource de autenticação
abstract class AuthDatasourceProtocol {
  /// Busca usuário por email
  Future<AuthUserModel?> getUserByEmail(String email);

  /// Busca o usuário atual (primeiro da tabela)
  Future<AuthUserModel?> getCurrentUser();

  /// Cria um novo usuário
  Future<AuthUserModel> createUser({
    required String email,
    String? name,
    String? phone,
  });

  /// Verifica se um email já existe
  Future<bool> emailExists(String email);

  /// Remove todos os usuários (logout)
  Future<void> deleteAllUsers();
}

/// Implementação do datasource de autenticação
/// Contém TODA a lógica de acesso ao banco de dados SQLite
class AuthDatasource implements AuthDatasourceProtocol {
  final DatabaseHelper _dbHelper;

  static const String _tableName = 'users';

  AuthDatasource({DatabaseHelper? dbHelper})
      : _dbHelper = dbHelper ?? DatabaseHelper();

  Future<Database> get _database async => await _dbHelper.database;

  @override
  Future<AuthUserModel?> getUserByEmail(String email) async {
    try {
      final db = await _database;
      final List<Map<String, dynamic>> maps = await db.query(
        _tableName,
        where: 'email = ?',
        whereArgs: [email],
        limit: 1,
      );

      if (maps.isEmpty) return null;

      return AuthUserModel.fromMap(maps.first);
    } catch (e) {
      print('❌ Erro ao buscar usuário por email: $e');
      return null;
    }
  }

  @override
  Future<AuthUserModel?> getCurrentUser() async {
    try {
      final db = await _database;
      final List<Map<String, dynamic>> maps = await db.query(
        _tableName,
        limit: 1,
      );

      if (maps.isEmpty) return null;

      return AuthUserModel.fromMap(maps.first);
    } catch (e) {
      print('❌ Erro ao buscar usuário atual: $e');
      return null;
    }
  }

  @override
  Future<AuthUserModel> createUser({
    required String email,
    String? name,
    String? phone,
  }) async {
    try {
      final db = await _database;
      final now = DateTime.now();

      final user = AuthUserModel(
        id: _generateUserId(),
        email: email.trim(),
        name: name?.trim() ?? email.split('@').first,
        phone: phone?.trim(),
        createdAt: now,
        updatedAt: now,
      );

      await db.insert(
        _tableName,
        user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      return user;
    } catch (e) {
      print('❌ Erro ao criar usuário: $e');
      rethrow;
    }
  }

  @override
  Future<bool> emailExists(String email) async {
    try {
      final db = await _database;
      final List<Map<String, dynamic>> maps = await db.query(
        _tableName,
        where: 'email = ?',
        whereArgs: [email],
        limit: 1,
      );

      return maps.isNotEmpty;
    } catch (e) {
      print('❌ Erro ao verificar se email existe: $e');
      return false;
    }
  }

  @override
  Future<void> deleteAllUsers() async {
    try {
      final db = await _database;
      await db.delete(_tableName);
    } catch (e) {
      print('❌ Erro ao deletar usuários: $e');
      rethrow;
    }
  }

  /// Gera um ID único para o usuário
  String _generateUserId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}
