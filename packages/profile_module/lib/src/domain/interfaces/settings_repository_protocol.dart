// domain/repositories/settings_repository_protocol.dart

import 'package:profile_module/src/domain/entity/app_settings_entity.dart';

abstract class SettingsRepositoryProtocol {
  Future<AppSettingsEntity> getSettings();
  Future<void> updateSettings(AppSettingsEntity settings);
  Future<void> clearCache();
  Future<String> getAppVersion();
}
