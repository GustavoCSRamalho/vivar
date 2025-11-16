// data/repositories/auth_repository_impl.dart

import 'package:sqflite/sqflite.dart';
import 'package:vivar/core/database/database_helper.dart';
import 'package:vivar/screens/splash/domain/repositories/auth_repository_protocol.dart';

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
}
