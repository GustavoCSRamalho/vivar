// data/datasources/onboarding/onboarding_datasource.dart

import 'package:shared_preferences/shared_preferences.dart';

/// Contrato abstrato para datasource de onboarding
abstract class OnboardingDatasourceProtocol {
  /// Marca o onboarding como completo
  Future<void> setOnboardingComplete(bool isComplete);

  /// Verifica se o onboarding foi completado
  Future<bool> isOnboardingComplete();
}

/// Implementação do datasource de onboarding
/// Contém TODA a lógica de acesso ao SharedPreferences
class OnboardingDatasource implements OnboardingDatasourceProtocol {
  static const String _onboardingKey = 'has_completed_onboarding';

  @override
  Future<void> setOnboardingComplete(bool isComplete) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_onboardingKey, isComplete);
    } catch (e) {
      print('❌ Erro ao salvar status do onboarding: $e');
      rethrow;
    }
  }

  @override
  Future<bool> isOnboardingComplete() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_onboardingKey) ?? false;
    } catch (e) {
      print('❌ Erro ao verificar onboarding: $e');
      return false;
    }
  }
}
