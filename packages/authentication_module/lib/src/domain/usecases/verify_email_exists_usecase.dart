// domain/usecases/auth/verify_email_exists_usecase.dart

import '../interfaces/auth_repository_protocol.dart';

class VerifyEmailExistsUseCase {
  final EmailVerificationProtocol _repository;

  VerifyEmailExistsUseCase(this._repository);

  Future<bool> execute(String email) async {
    if (email.trim().isEmpty) {
      throw Exception('Email é obrigatório');
    }

    if (!email.contains('@') || !email.contains('.')) {
      throw Exception('Email inválido');
    }

    try {
      return await _repository.verifyEmailExists(email.trim());
    } catch (e) {
      print('❌ Erro ao verificar email: $e');
      rethrow;
    }
  }
}
