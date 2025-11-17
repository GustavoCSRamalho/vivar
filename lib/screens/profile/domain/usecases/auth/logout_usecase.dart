// domain/usecases/auth/logout_usecase.dart

import 'package:vivar/screens/auth/domain/repositories/auth_repository_protocol.dart';

class LogoutUseCase {
  final AuthRepositoryProtocol _repository;

  LogoutUseCase(this._repository);

  Future<void> execute() async {
    try {
      await _repository.logout();
    } catch (e) {
      print('❌ Erro ao fazer logout: $e');
      rethrow;
    }
  }
}
