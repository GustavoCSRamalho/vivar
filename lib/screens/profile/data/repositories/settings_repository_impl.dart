// data/repositories/settings_repository_impl.dart

import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:vivar/screens/profile/domain/entities/app_settings_entity.dart';
import 'package:vivar/screens/profile/domain/repositories/settings_repository_protocol.dart';

class SettingsRepositoryImpl implements SettingsRepositoryProtocol {
  static const String _darkModeKey = 'dark_mode';
  static const String _languageKey = 'language';
  static const String _distanceUnitKey = 'distance_unit';
  static const String _notificationsKey = 'notifications_enabled';
  static const String _locationKey = 'location_enabled';

  @override
  Future<AppSettingsEntity> getSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      return AppSettingsEntity(
        darkMode: prefs.getBool(_darkModeKey) ?? false,
        language: prefs.getString(_languageKey) ?? 'pt_BR',
        distanceUnit: prefs.getString(_distanceUnitKey) ?? 'km',
        notificationsEnabled: prefs.getBool(_notificationsKey) ?? true,
        locationEnabled: prefs.getBool(_locationKey) ?? true,
      );
    } catch (e) {
      print('❌ Erro ao buscar configurações: $e');
      return AppSettingsEntity();
    }
  }

  @override
  Future<void> updateSettings(AppSettingsEntity settings) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setBool(_darkModeKey, settings.darkMode);
      await prefs.setString(_languageKey, settings.language);
      await prefs.setString(_distanceUnitKey, settings.distanceUnit);
      await prefs.setBool(_notificationsKey, settings.notificationsEnabled);
      await prefs.setBool(_locationKey, settings.locationEnabled);

      print('✅ Configurações atualizadas');
    } catch (e) {
      print('❌ Erro ao atualizar configurações: $e');
      rethrow;
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys().where((key) => key.startsWith('cache_'));
      for (var key in keys) {
        await prefs.remove(key);
      }
      print('✅ Cache limpo');
    } catch (e) {
      print('❌ Erro ao limpar cache: $e');
      rethrow;
    }
  }

  @override
  Future<String> getAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      return '${packageInfo.version} (${packageInfo.buildNumber})';
    } catch (e) {
      print('❌ Erro ao buscar versão: $e');
      return '1.0.0';
    }
  }
}
