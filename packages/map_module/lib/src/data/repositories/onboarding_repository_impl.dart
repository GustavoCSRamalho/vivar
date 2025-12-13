// data/repositories/onboarding_repository_impl.dart

import 'package:onboarding_module/src/data/domain/interfaces/onboarding_repository_protocol.dart';
import '../datasource/onboarding_datasource.dart';

/// Implementação do repositório de onboarding
/// Delega operações de dados para o datasource
class OnboardingRepositoryImpl implements OnboardingRepositoryProtocol {
  final OnboardingDatasourceProtocol _datasource;

  OnboardingRepositoryImpl({required OnboardingDatasourceProtocol datasource})
    : _datasource = datasource;

  @override
  Future<void> markOnboardingComplete() async {
    try {
      await _datasource.setOnboardingComplete(true);
      print('✅ Onboarding marcado como completo');
    } catch (e) {
      print('❌ Erro ao marcar onboarding: $e');
      rethrow;
    }
  }

  @override
  Future<bool> hasCompletedOnboarding() {
    return _datasource.isOnboardingComplete();
  }
}
