// domain/usecases/auth/login_with_email_usecase.dart

import '../../entity/auth/auth_user_entity.dart';
import '../../entity/login/login_credentials_entity.dart';
import '../../interface/auth/auth_repository_protocol.dart';

class LoginWithEmailUseCase {
  final EmailLoginProtocol _repository;

  LoginWithEmailUseCase(this._repository);

  Future<AuthUserEntity> execute(String email, String password) async {
    if (email.trim().isEmpty) {
      throw Exception('Email é obrigatório');
    }

    if (!email.contains('@') || !email.contains('.')) {
      throw Exception('Email inválido');
    }

    if (password.trim().isEmpty) {
      throw Exception('Senha é obrigatória');
    }

    if (password.length < 6) {
      throw Exception('Senha deve ter no mínimo 6 caracteres');
    }

    try {
      final credentials = LoginCredentialsEntity(
        email: email.trim(),
        password: password,
      );
      return await _repository.loginWithEmail(credentials);
    } catch (e) {
      print('❌ Erro ao fazer login: $e');
      rethrow;
    }
  }
}
