// data/usecases/splash/check_authentication_usecase_impl.dart

import 'package:vivar/domain/interface/auth/auth_repository_protocol.dart';
import 'package:vivar/domain/interface/check/check_authentication_protocol.dart';

class CheckAuthenticationUseCase implements CheckAuthenticationProtocol {
  final AuthRepositoryProtocol _authRepository;

  CheckAuthenticationUseCase(this._authRepository);

  @override
  Future<bool> execute() async {
    try {
      return await _authRepository.isUserLoggedIn();
    } catch (e) {
      print('❌ Erro ao verificar autenticação: $e');
      return false;
    }
  }
}
