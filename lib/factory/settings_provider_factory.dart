// presentation/providers/settings_provider_factory.dart

import 'package:vivar/screens/auth/data/repositories/auth_repository_impl.dart';
import 'package:vivar/screens/profile/data/repositories/settings_repository_impl.dart';
import 'package:vivar/screens/profile/domain/usecases/auth/logout_usecase.dart';
import 'package:vivar/screens/profile/domain/usecases/settings/clear_cache_usecase.dart';
import 'package:vivar/screens/profile/domain/usecases/settings/get_app_version_usecase.dart';
import 'package:vivar/screens/profile/domain/usecases/settings/get_settings_usecase.dart';
import 'package:vivar/screens/profile/domain/usecases/settings/update_settings_usecase.dart';
import 'package:vivar/screens/profile/presentation/providers/settings_provider.dart';

class SettingsProviderFactory {
  static SettingsProvider create() {
    final settingsRepository = SettingsRepositoryImpl();
    final authRepository = AuthRepositoryImpl();

    final getSettingsUseCase = GetSettingsUseCase(settingsRepository);
    final updateSettingsUseCase = UpdateSettingsUseCase(settingsRepository);
    final clearCacheUseCase = ClearCacheUseCase(settingsRepository);
    final getAppVersionUseCase = GetAppVersionUseCase(settingsRepository);
    final logoutUseCase = LogoutUseCase(authRepository);

    return SettingsProvider(
      getSettingsUseCase: getSettingsUseCase,
      updateSettingsUseCase: updateSettingsUseCase,
      clearCacheUseCase: clearCacheUseCase,
      getAppVersionUseCase: getAppVersionUseCase,
      logoutUseCase: logoutUseCase,
    );
  }
}
