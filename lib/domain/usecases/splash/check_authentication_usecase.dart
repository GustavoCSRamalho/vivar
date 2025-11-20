// data/usecases/splash/check_authentication_usecase_impl.dart

import 'package:vivar/domain/interface/auth/auth_repository_protocol.dart';

class UserLoggedInUseCase {
  final UserLoggedInProtocol _authRepository;

  UserLoggedInUseCase(this._authRepository);

  Future<bool> execute() async {
    try {
      return await _authRepository.isUserLoggedIn();
    } catch (e) {
      print('❌ Erro ao verificar autenticação: $e');
      return false;
    }
  }
}
