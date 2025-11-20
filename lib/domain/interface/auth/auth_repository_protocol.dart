// domain/repositories/auth_repository_protocol.dart

import 'package:vivar/domain/entity/register/register_user_entity.dart';

import '../../entity/auth/auth_user_entity.dart';
import '../../entity/login/login_credentials_entity.dart';

// ===============================================
// LOGIN PROTOCOLS
// ===============================================

/// Login via Email
abstract class EmailLoginProtocol {
  Future<AuthUserEntity> loginWithEmail(LoginCredentialsEntity credentials);
}

/// Login via Google
abstract class GoogleLoginProtocol {
  Future<AuthUserEntity> loginWithGoogle();
}

/// Login via Apple
abstract class AppleLoginProtocol {
  Future<AuthUserEntity> loginWithApple();
}

// ===============================================
// REGISTRATION PROTOCOLS
// ===============================================

abstract class RegisterUserProtocol {
  Future<AuthUserEntity> registerUser(RegisterUserEntity registerData);
}

/// Verifica se um e-mail já está cadastrado
abstract class EmailVerificationProtocol {
  Future<bool> verifyEmailExists(String email);
}

// ===============================================
// SESSION / STATE PROTOCOLS
// ===============================================

/// Obter usuário atual
abstract class CurrentUserProtocol {
  Future<AuthUserEntity?> getCurrentUser();
}

/// Verifica se há sessão ativa
abstract class UserLoggedInProtocol {
  Future<bool> isUserLoggedIn();
}

// ===============================================
// ACCOUNT / MANAGEMENT PROTOCOLS
// ===============================================

/// Logout
abstract class LogoutProtocol {
  Future<void> logout();
}

/// Enviar email de reset de senha
abstract class PasswordResetProtocol {
  Future<void> sendPasswordResetEmail(String email);
}
