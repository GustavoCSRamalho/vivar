// presentation/providers/splash_provider_factory.dart

import 'package:vivar/screens/splash/data/repositories/auth_repository_impl.dart';
import 'package:vivar/domain/usecases/splash/check_authentication_usecase.dart';
import 'package:vivar/domain/usecases/splash/initialize_app_usecase.dart';
import 'package:vivar/screens/splash/presentation/providers/splash_provider.dart';

class SplashProviderFactory {
  static SplashProvider create() {
    final authRepository = AuthRepositoryImpl();

    final checkAuthenticationUseCase = CheckAuthenticationUseCase(
      authRepository,
    );
    final initializeAppUseCase = InitializeAppUseCase();

    return SplashProvider(
      checkAuthenticationUseCase: checkAuthenticationUseCase,
      initializeAppUseCase: initializeAppUseCase,
    );
  }
}
