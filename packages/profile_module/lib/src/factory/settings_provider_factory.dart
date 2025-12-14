// presentation/providers/settings_provider_factory.dart

import 'package:profile_module/src/data/datasource/user/auth_datasource.dart';
import 'package:profile_module/src/data/repositories/auth_repository_impl.dart';
import 'package:profile_module/src/domain/usecases/logout_usecase.dart';

import '../data/datasource/settings_local_datasource.dart';
import '../data/repositories/settings_repository_impl.dart';
import '../presentation/providers/settings_provider.dart';

import '../domain/usecases/clear_cache_usecase.dart';
import '../domain/usecases/get_app_version_usecase.dart';
import '../domain/usecases/get_settings_usecase.dart';
import '../domain/usecases/update_settings_usecase.dart';

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
