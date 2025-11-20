// presentation/providers/settings_provider_factory.dart

import 'package:vivar/domain/usecases/auth/logout_usecase.dart';
import 'package:vivar/screens/auth/data/datasource/auth_datasource.dart';
import 'package:vivar/screens/auth/data/repositories/auth_repository_impl.dart';
import 'package:vivar/screens/profile/data/datasource/settings_local_datasource.dart';
import 'package:vivar/screens/profile/data/repositories/settings_repository_impl.dart';
import 'package:vivar/screens/profile/presentation/providers/settings_provider.dart';

import '../domain/usecases/settings/clear_cache_usecase.dart';
import '../domain/usecases/settings/get_app_version_usecase.dart';
import '../domain/usecases/settings/get_settings_usecase.dart';
import '../domain/usecases/settings/update_settings_usecase.dart';

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
