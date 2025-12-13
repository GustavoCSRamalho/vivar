import 'package:profile_module/src/domain/entity/app_settings_entity.dart';
import 'package:profile_module/src/domain/interfaces/settings_repository_protocol.dart';
import '../datasource/settings_local_datasource.dart';

class SettingsRepositoryImpl implements SettingsRepositoryProtocol {
  final SettingsLocalDataSourceProtocol datasource;

  SettingsRepositoryImpl({required this.datasource});

  @override
  Future<AppSettingsEntity> getSettings() {
    return datasource.getSettings();
  }

  @override
  Future<void> updateSettings(AppSettingsEntity settings) {
    return datasource.updateSettings(settings);
  }

  @override
  Future<void> clearCache() {
    return datasource.clearCache();
  }

  @override
  Future<String> getAppVersion() {
    return datasource.getAppVersion();
  }
}
