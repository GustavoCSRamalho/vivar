// domain/usecases/auth/login_with_apple_usecase.dart

import '../../entity/auth_user_entity.dart';
import '../../interface/auth/auth_repository_protocol.dart';

class LoginWithAppleUseCase {
  final AppleLoginProtocol _repository;

  LoginWithAppleUseCase(this._repository);

  Future<AuthUserEntity> execute() async {
    try {
      return await _repository.loginWithApple();
    } catch (e) {
      print('❌ Erro ao fazer login com Apple: $e');
      rethrow;
    }
  }
}
