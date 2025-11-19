// data/repositories/auth_repository_impl.dart

import 'package:sqflite/sqflite.dart';
import 'package:vivar/core/database/database_helper.dart';
import 'package:vivar/domain/entity/auth_user_entity.dart';
import 'package:vivar/domain/entity/login_credentials_entity.dart';
import 'package:vivar/domain/entity/register_user_entity.dart';

import '../../../../domain/interface/auth/auth_repository_protocol.dart';

class AuthRepositoryImpl implements AuthRepositoryProtocol {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final String _userTableName = 'users';

  Future<Database> get _database async => await _dbHelper.database;

  @override
  Future<bool> isUserLoggedIn() async {
    try {
      final db = await _database;
      final List<Map<String, dynamic>> maps = await db.query(
        _userTableName,
        limit: 1,
      );
      return maps.isNotEmpty;
    } catch (e) {
      print('❌ Erro ao verificar autenticação: $e');
      return false;
    }
  }

  @override
  Future<String?> getCurrentUserId() async {
    try {
      final db = await _database;
      final List<Map<String, dynamic>> maps = await db.query(
        _userTableName,
        limit: 1,
      );
      if (maps.isEmpty) return null;
      return maps.first['id'] as String?;
    } catch (e) {
      print('❌ Erro ao buscar ID do usuário: $e');
      return null;
    }
  }

  @override
  Future<AuthUserEntity?> getCurrentUser() {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }

  @override
  Future<AuthUserEntity> loginWithApple() {
    // TODO: implement loginWithApple
    throw UnimplementedError();
  }

  @override
  Future<AuthUserEntity> loginWithEmail(LoginCredentialsEntity credentials) {
    // TODO: implement loginWithEmail
    throw UnimplementedError();
  }

  @override
  Future<AuthUserEntity> loginWithGoogle() {
    // TODO: implement loginWithGoogle
    throw UnimplementedError();
  }

  @override
  Future<void> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<AuthUserEntity> registerUser(RegisterUserEntity registerData) {
    // TODO: implement registerUser
    throw UnimplementedError();
  }

  @override
  Future<void> sendPasswordResetEmail(String email) {
    // TODO: implement sendPasswordResetEmail
    throw UnimplementedError();
  }

  @override
  Future<bool> verifyEmailExists(String email) {
    // TODO: implement verifyEmailExists
    throw UnimplementedError();
  }
}
