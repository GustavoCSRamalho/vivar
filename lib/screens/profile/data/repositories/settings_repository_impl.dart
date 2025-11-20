import 'package:vivar/domain/entity/settings/app_settings_entity.dart';
import 'package:vivar/domain/interface/settings/settings_repository_protocol.dart';
import 'package:vivar/screens/profile/data/datasource/settings_local_datasource.dart';

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
