// data/repositories/auth_repository_impl.dart

import 'package:authentication_module/src/domain/entity/login_credentials_entity.dart';
import 'package:authentication_module/src/domain/entity/register_user_entity.dart';

import '../model/auth_user_model.dart';
import '../../domain/entity/auth_user_entity.dart';
import '../../domain/interfaces/auth_repository_protocol.dart';
import '../datasource/auth_datasource.dart';

/// Implementação do repositório de autenticação
/// Delega operações de dados para o datasource
/// Implementa múltiplos protocolos de autenticação
class AuthRepositoryImpl
    implements
        EmailLoginProtocol,
        GoogleLoginProtocol,
        AppleLoginProtocol,
        RegisterUserProtocol,
        LogoutProtocol,
        PasswordResetProtocol,
        EmailVerificationProtocol,
        UserLoggedInProtocol {
  final AuthDatasourceProtocol _datasource;

  AuthRepositoryImpl({required AuthDatasourceProtocol datasource})
      : _datasource = datasource;

  @override
  Future<AuthUserEntity> loginWithEmail(
    LoginCredentialsEntity credentials,
  ) async {
    final user = await _datasource.getUserByEmail(credentials.email);

    if (user == null) {
      final newUser = await _datasource.createUser(email: credentials.email);
      return _modelToEntity(newUser);
    }

    return _modelToEntity(user);
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
  Future<void> logout() {
    return _datasource.deleteAllUsers();
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await Future.delayed(Duration(seconds: 1));
    print('✅ Email de recuperação enviado para: $email');
  }

  @override
  Future<AuthUserEntity?> getCurrentUser() async {
    final user = await _datasource.getCurrentUser();
    return user != null ? _modelToEntity(user) : null;
  }

  @override
  Future<bool> isUserLoggedIn() async {
    final user = await getCurrentUser();
    return user != null;
  }

  @override
  Future<AuthUserEntity> registerUser(RegisterUserEntity registerData) async {
    final emailAlreadyExists = await _datasource.emailExists(
      registerData.email,
    );

    if (emailAlreadyExists) {
      throw Exception('Este email já está cadastrado');
    }

    final user = await _datasource.createUser(
      email: registerData.email,
      name: registerData.name,
      phone: registerData.phone,
    );

    return _modelToEntity(user);
  }

  @override
  Future<bool> verifyEmailExists(String email) {
    return _datasource.emailExists(email);
  }

  /// Converte UserModel (data layer) para AuthUserEntity (domain layer)
  AuthUserEntity _modelToEntity(AuthUserModel model) {
    return AuthUserEntity(
      id: model.id,
      email: model.email,
      name: model.name,
      avatarUrl: model.avatarUrl,
      phone: model.phone,
      createdAt: model.createdAt,
    );
  }
}
