// presentation/providers/splash_provider_factory.dart

import 'package:vivar/screens/splash/data/repositories/auth_repository_impl.dart';
import 'package:vivar/screens/splash/data/usecases/splash/check_authentication_usecase_impl.dart';
import 'package:vivar/screens/splash/data/usecases/splash/initialize_app_usecase_impl.dart';
import 'package:vivar/screens/splash/presentation/providers/splash_provider.dart';

class SplashProviderFactory {
  static SplashProvider create() {
    final authRepository = AuthRepositoryImpl();

    final checkAuthenticationUseCase = CheckAuthenticationUseCaseImpl(
      authRepository,
    );
    final initializeAppUseCase = InitializeAppUseCaseImpl();

    return SplashProvider(
      checkAuthenticationUseCase: checkAuthenticationUseCase,
      initializeAppUseCase: initializeAppUseCase,
    );
  }
}
