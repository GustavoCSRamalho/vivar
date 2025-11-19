// data/repositories/onboarding_repository_impl.dart

import 'package:shared_preferences/shared_preferences.dart';
import 'package:vivar/domain/interface/onboarding/onboarding_repository_protocol.dart';

class OnboardingRepositoryImpl implements OnboardingRepositoryProtocol {
  static const String _onboardingKey = 'has_completed_onboarding';

  @override
  Future<void> markOnboardingComplete() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_onboardingKey, true);
      print('✅ Onboarding marcado como completo');
    } catch (e) {
      print('❌ Erro ao marcar onboarding: $e');
      rethrow;
    }
  }

  @override
  Future<bool> hasCompletedOnboarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_onboardingKey) ?? false;
    } catch (e) {
      print('❌ Erro ao verificar onboarding: $e');
      return false;
    }
  }
}
