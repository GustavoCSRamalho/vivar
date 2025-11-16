// data/usecases/splash/check_authentication_usecase_impl.dart

import 'package:vivar/screens/splash/domain/repositories/auth_repository_protocol.dart';
import 'package:vivar/screens/splash/domain/usecases/splash/check_authentication_usecase.dart';

class CheckAuthenticationUseCaseImpl implements CheckAuthenticationUseCase {
  final AuthRepositoryProtocol _authRepository;

  CheckAuthenticationUseCaseImpl(this._authRepository);

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
