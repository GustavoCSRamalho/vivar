// domain/repositories/auth_repository_protocol.dart

import 'package:vivar/domain/entity/register_user_entity.dart';

import '../../entity/auth_user_entity.dart';
import '../../entity/login_credentials_entity.dart';

abstract class AuthRepositoryProtocol {
  Future<AuthUserEntity> loginWithEmail(LoginCredentialsEntity credentials);
  Future<AuthUserEntity> loginWithGoogle();
  Future<AuthUserEntity> loginWithApple();
  Future<AuthUserEntity> registerUser(RegisterUserEntity registerData);
  Future<void> logout();
  Future<void> sendPasswordResetEmail(String email);
  Future<AuthUserEntity?> getCurrentUser();
  Future<bool> verifyEmailExists(String email);
  Future<bool> isUserLoggedIn();
}
