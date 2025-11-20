// domain/usecases/auth/send_password_reset_usecase.dart

import '../../interface/auth/auth_repository_protocol.dart';

class SendPasswordResetUseCase {
  final PasswordResetProtocol _repository;

  SendPasswordResetUseCase(this._repository);

  Future<void> execute(String email) async {
    if (email.trim().isEmpty) {
      throw Exception('Email é obrigatório');
    }

    if (!email.contains('@') || !email.contains('.')) {
      throw Exception('Email inválido');
    }

    try {
      await _repository.sendPasswordResetEmail(email.trim());
    } catch (e) {
      print('❌ Erro ao enviar email de recuperação: $e');
      rethrow;
    }
  }
}
