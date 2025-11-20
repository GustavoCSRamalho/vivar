// domain/usecases/auth/register_user_usecase.dart

import '../../entity/auth_user_entity.dart';
import '../../entity/register_user_entity.dart';
import '../../interface/auth/auth_repository_protocol.dart';

class RegisterUserUseCase {
  final RegisterUserProtocol _repository;

  RegisterUserUseCase(this._repository);

  Future<AuthUserEntity> execute(RegisterUserEntity registerData) async {
    // Validações
    if (registerData.name.trim().isEmpty) {
      throw Exception('Nome é obrigatório');
    }

    if (registerData.name.trim().length < 3) {
      throw Exception('Nome deve ter no mínimo 3 caracteres');
    }

    if (registerData.email.trim().isEmpty) {
      throw Exception('Email é obrigatório');
    }

    if (!registerData.email.contains('@') ||
        !registerData.email.contains('.')) {
      throw Exception('Email inválido');
    }

    if (registerData.password.trim().isEmpty) {
      throw Exception('Senha é obrigatória');
    }

    if (registerData.password.length < 6) {
      throw Exception('Senha deve ter no mínimo 6 caracteres');
    }

    try {
      return await _repository.registerUser(registerData);
    } catch (e) {
      print('❌ Erro ao registrar usuário: $e');
      rethrow;
    }
  }
}
