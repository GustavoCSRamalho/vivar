// presentation/providers/register_provider_factory.dart

import 'package:vivar/screens/auth/data/datasource/auth_datasource.dart';
import 'package:vivar/screens/auth/data/repositories/auth_repository_impl.dart';
import 'package:vivar/domain/usecases/auth/login_with_apple_usecase.dart';
import 'package:vivar/domain/usecases/auth/login_with_google_usecase.dart';
import 'package:vivar/domain/usecases/auth/register_user_usecase.dart';
import 'package:vivar/screens/auth/presentation/providers/register_provider.dart';

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
