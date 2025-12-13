// presentation/providers/settings_provider.dart

import 'package:flutter/foundation.dart';
import 'package:vivar/domain/entity/settings/app_settings_entity.dart';
import 'package:vivar/screens/auth/domain/usecases/logout_usecase.dart';
import '../../../../domain/usecases/settings/clear_cache_usecase.dart';
import '../../../../domain/usecases/settings/get_app_version_usecase.dart';
import '../../../../domain/usecases/settings/get_settings_usecase.dart';
import '../../../../domain/usecases/settings/update_settings_usecase.dart';

class SettingsProvider with ChangeNotifier {
  final GetSettingsUseCase _getSettingsUseCase;
  final UpdateSettingsUseCase _updateSettingsUseCase;
  final ClearCacheUseCase _clearCacheUseCase;
  final GetAppVersionUseCase _getAppVersionUseCase;
  final LogoutUseCase _logoutUseCase;

  SettingsProvider({
    required GetSettingsUseCase getSettingsUseCase,
    required UpdateSettingsUseCase updateSettingsUseCase,
    required ClearCacheUseCase clearCacheUseCase,
    required GetAppVersionUseCase getAppVersionUseCase,
    required LogoutUseCase logoutUseCase,
  }) : _getSettingsUseCase = getSettingsUseCase,
       _updateSettingsUseCase = updateSettingsUseCase,
       _clearCacheUseCase = clearCacheUseCase,
       _getAppVersionUseCase = getAppVersionUseCase,
       _logoutUseCase = logoutUseCase;

  AppSettingsEntity _settings = AppSettingsEntity();
  String _appVersion = '1.0.0';
  bool _isLoading = false;
  String? _error;

  AppSettingsEntity get settings => _settings;
  String get appVersion => _appVersion;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadSettings() async {
    _setLoading(true);
    _error = null;

    try {
      _settings = await _getSettingsUseCase.execute();
      _appVersion = await _getAppVersionUseCase.execute();
      debugPrint('✅ Configurações carregadas');
    } catch (e) {
      _error = 'Erro ao carregar configurações';
      debugPrint('❌ Erro ao carregar configurações: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> toggleDarkMode(bool value) async {
    final newSettings = _settings.copyWith(darkMode: value);
    await _updateSetting(newSettings);
  }

  Future<void> updateLanguage(String language) async {
    final newSettings = _settings.copyWith(language: language);
    await _updateSetting(newSettings);
  }

  Future<void> updateDistanceUnit(String unit) async {
    final newSettings = _settings.copyWith(distanceUnit: unit);
    await _updateSetting(newSettings);
  }

  Future<void> toggleNotifications(bool value) async {
    final newSettings = _settings.copyWith(notificationsEnabled: value);
    await _updateSetting(newSettings);
  }

  Future<void> toggleLocation(bool value) async {
    final newSettings = _settings.copyWith(locationEnabled: value);
    await _updateSetting(newSettings);
  }

  Future<void> _updateSetting(AppSettingsEntity newSettings) async {
    try {
      await _updateSettingsUseCase.execute(newSettings);
      _settings = newSettings;
      notifyListeners();
      debugPrint('✅ Configuração atualizada');
    } catch (e) {
      _error = 'Erro ao atualizar configuração';
      debugPrint('❌ Erro ao atualizar: $e');
      notifyListeners();
    }
  }

  Future<bool> clearCache() async {
    _setLoading(true);
    _error = null;

    try {
      await _clearCacheUseCase.execute();
      debugPrint('✅ Cache limpo');
      _setLoading(false);
      return true;
    } catch (e) {
      _error = 'Erro ao limpar cache';
      debugPrint('❌ Erro ao limpar cache: $e');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> logout() async {
    _setLoading(true);
    _error = null;

    try {
      await _logoutUseCase.execute();
      debugPrint('✅ Logout realizado');
      _setLoading(false);
      return true;
    } catch (e) {
      _error = 'Erro ao fazer logout';
      debugPrint('❌ Erro ao fazer logout: $e');
      _setLoading(false);
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
