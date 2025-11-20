// presentation/providers/splash_provider_factory.dart

import 'package:vivar/screens/splash/data/datasource/splash_user_local_datasource.dart';
import 'package:vivar/screens/splash/data/repositories/splash_repository_impl.dart';
import 'package:vivar/domain/usecases/splash/check_authentication_usecase.dart';
import 'package:vivar/domain/usecases/splash/initialize_app_usecase.dart';
import 'package:vivar/screens/splash/presentation/providers/splash_provider.dart';

class SplashProviderFactory {
  static SplashProvider create() {
    final splashUserLocalDataSourceImpl = SplashUserLocalDataSourceImpl();
    final authRepository = SplashRepositoryImpl(
      datasource: splashUserLocalDataSourceImpl,
    );

    final checkAuthenticationUseCase = UserLoggedInUseCase(authRepository);
    final initializeAppUseCase = InitializeAppUseCase();

    return SplashProvider(
      userLoggedInUseCase: checkAuthenticationUseCase,
      initializeAppUseCase: initializeAppUseCase,
    );
  }
}
