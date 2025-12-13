// presentation/providers/splash_provider_factory.dart

import 'package:splash_module/src/data/datasource/splash_user_local_datasource.dart';
import 'package:splash_module/src/data/repositories/splash_repository_impl.dart';
import 'package:splash_module/src/domain/usecase/check_authentication_usecase.dart';
import 'package:splash_module/src/domain/usecase/initialize_app_usecase.dart';
import 'package:splash_module/src/presentation/providers/splash_provider.dart';

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
