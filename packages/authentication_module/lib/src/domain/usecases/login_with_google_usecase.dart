// domain/usecases/auth/login_with_google_usecase.dart

import '../entity/auth_user_entity.dart';
import '../interfaces/auth_repository_protocol.dart';

class LoginWithGoogleUseCase {
  final GoogleLoginProtocol _repository;

  LoginWithGoogleUseCase(this._repository);

  Future<AuthUserEntity> execute() async {
    try {
      return await _repository.loginWithGoogle();
    } catch (e) {
      print('❌ Erro ao fazer login com Google: $e');
      rethrow;
    }
  }
}
