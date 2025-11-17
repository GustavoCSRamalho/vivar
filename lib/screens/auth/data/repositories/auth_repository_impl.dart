// data/repositories/auth_repository_impl.dart

import 'package:sqflite/sqflite.dart';
import 'package:vivar/core/database/database_helper.dart';
import 'package:vivar/screens/auth/domain/entities/auth_user_entity.dart';
import 'package:vivar/screens/auth/domain/entities/login_credentials_entity.dart';
import 'package:vivar/screens/auth/domain/entities/register_user_entity.dart';
import 'package:vivar/screens/home/data/models/user_model.dart';

import '../../domain/repositories/auth_repository_protocol.dart';

class AuthRepositoryImpl implements AuthRepositoryProtocol {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final String _userTableName = 'users';

  Future<Database> get _database async => await _dbHelper.database;

  @override
  Future<AuthUserEntity> loginWithEmail(
    LoginCredentialsEntity credentials,
  ) async {
    final db = await _database;

    final List<Map<String, dynamic>> maps = await db.query(
      _userTableName,
      where: 'email = ?',
      whereArgs: [credentials.email],
      limit: 1,
    );

    if (maps.isEmpty) {
      final newUser = await _createUser(credentials.email);
      return _modelToEntity(newUser);
    }

    return _modelToEntity(UserModel.fromMap(maps.first));
  }

  @override
  Future<AuthUserEntity> loginWithGoogle() async {
    await Future.delayed(Duration(seconds: 1));

    final email = 'google.user@example.com';
    return await loginWithEmail(
      LoginCredentialsEntity(email: email, password: 'google_auth'),
    );
  }

  @override
  Future<AuthUserEntity> loginWithApple() async {
    await Future.delayed(Duration(seconds: 1));

    final email = 'apple.user@example.com';
    return await loginWithEmail(
      LoginCredentialsEntity(email: email, password: 'apple_auth'),
    );
  }

  @override
  Future<void> logout() async {
    final db = await _database;
    await db.delete(_userTableName);
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await Future.delayed(Duration(seconds: 1));
    print('✅ Email de recuperação enviado para: $email');
  }

  @override
  Future<AuthUserEntity?> getCurrentUser() async {
    final db = await _database;
    final List<Map<String, dynamic>> maps = await db.query(
      _userTableName,
      limit: 1,
    );

    if (maps.isEmpty) return null;
    return _modelToEntity(UserModel.fromMap(maps.first));
  }

  @override
  Future<bool> isUserLoggedIn() async {
    final user = await getCurrentUser();
    return user != null;
  }

  Future<UserModel> _createUser(String email) async {
    final db = await _database;
    final now = DateTime.now();

    final user = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      name: email.split('@').first,
      createdAt: now,
      updatedAt: now,
    );

    await db.insert(
      _userTableName,
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return user;
  }

  AuthUserEntity _modelToEntity(UserModel model) {
    return AuthUserEntity(
      id: model.id,
      email: model.email,
      name: model.name,
      avatarUrl: model.avatarUrl,
      phone: model.phone,
      createdAt: model.createdAt,
    );
  }

  @override
  Future<String?> getCurrentUserId() {
    // TODO: implement getCurrentUserId
    throw UnimplementedError();
  }

  @override
  Future<AuthUserEntity> registerUser(RegisterUserEntity registerData) async {
    final db = await _database;

    // Verificar se email já existe
    final existingUsers = await db.query(
      _userTableName,
      where: 'email = ?',
      whereArgs: [registerData.email],
      limit: 1,
    );

    if (existingUsers.isNotEmpty) {
      throw Exception('Este email já está cadastrado');
    }

    final now = DateTime.now();
    final user = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: registerData.email.trim(),
      name: registerData.name.trim(),
      phone: registerData.phone?.trim(),
      createdAt: now,
      updatedAt: now,
    );

    await db.insert(
      _userTableName,
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return _modelToEntity(user);
  }

  @override
  Future<bool> verifyEmailExists(String email) async {
    final db = await _database;

    final List<Map<String, dynamic>> maps = await db.query(
      _userTableName,
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );

    return maps.isNotEmpty;
  }
}
