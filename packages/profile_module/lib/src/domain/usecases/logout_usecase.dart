// domain/usecases/auth/logout_usecase.dart

import 'package:profile_module/src/domain/interfaces/auth_repository_protocol.dart';

class LogoutUseCase {
  final LogoutProtocol _repository;

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
