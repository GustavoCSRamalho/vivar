// presentation/providers/login_provider_factory.dart

import '../data/datasource/auth_datasource.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../domain/usecases/login_with_apple_usecase.dart';
import '../domain/usecases/login_with_email_usecase.dart';
import '../domain/usecases/login_with_google_usecase.dart';
import '../domain/usecases/send_password_reset_usecase.dart';
import '../presentation/login/login_provider.dart';

class LoginProviderFactory {
  static LoginProvider create() {
    final datasource = AuthDatasource();
    final repository = AuthRepositoryImpl(datasource: datasource);

    final loginWithEmailUseCase = LoginWithEmailUseCase(repository);
    final loginWithGoogleUseCase = LoginWithGoogleUseCase(repository);
    final loginWithAppleUseCase = LoginWithAppleUseCase(repository);
    final sendPasswordResetUseCase = SendPasswordResetUseCase(repository);

    return LoginProvider(
      loginWithEmailUseCase: loginWithEmailUseCase,
      loginWithGoogleUseCase: loginWithGoogleUseCase,
      loginWithAppleUseCase: loginWithAppleUseCase,
      sendPasswordResetUseCase: sendPasswordResetUseCase,
    );
  }
}
