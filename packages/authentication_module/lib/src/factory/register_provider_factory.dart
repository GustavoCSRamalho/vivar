// presentation/providers/register_provider_factory.dart

import '../data/datasource/auth_datasource.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../domain/usecases/login_with_apple_usecase.dart';
import '../domain/usecases/login_with_google_usecase.dart';
import '../domain/usecases/register_user_usecase.dart';
import '../presentation/register/register_provider.dart';

class RegisterProviderFactory {
  static RegisterProvider create() {
    final datasource = AuthDatasource();
    final repository = AuthRepositoryImpl(datasource: datasource);

    final registerUserUseCase = RegisterUserUseCase(repository);
    final loginWithGoogleUseCase = LoginWithGoogleUseCase(repository);
    final loginWithAppleUseCase = LoginWithAppleUseCase(repository);

    return RegisterProvider(
      registerUserUseCase: registerUserUseCase,
      loginWithGoogleUseCase: loginWithGoogleUseCase,
      loginWithAppleUseCase: loginWithAppleUseCase,
    );
  }
}
