// presentation/providers/settings_provider_factory.dart

import '../../packages/authentication_module/lib/src/domain/usecases/logout_usecase.dart';
import '../../packages/authentication_module/lib/src/data/datasource/auth_datasource.dart';
import '../../packages/authentication_module/lib/src/data/repositories/auth_repository_impl.dart';
import '../../packages/profile_module/lib/src/data/datasource/settings_local_datasource.dart';
import '../../packages/profile_module/lib/src/data/repositories/settings_repository_impl.dart';
import '../../packages/profile_module/lib/src/presentation/providers/settings_provider.dart';

import '../../packages/profile_module/lib/src/domain/usecases/clear_cache_usecase.dart';
import '../../packages/profile_module/lib/src/domain/usecases/get_app_version_usecase.dart';
import '../../packages/profile_module/lib/src/domain/usecases/get_settings_usecase.dart';
import '../../packages/profile_module/lib/src/domain/usecases/update_settings_usecase.dart';

class SettingsProviderFactory {
  static SettingsProvider create() {
    final datasource = AuthDatasource();
    final settingsDatasource = SettingsLocalDataSourceImpl();
    final settingsRepository = SettingsRepositoryImpl(
      datasource: settingsDatasource,
    );
    final authRepository = AuthRepositoryImpl(datasource: datasource);

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
