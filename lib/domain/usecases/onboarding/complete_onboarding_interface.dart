import '../../interface/onboarding/onboarding_repository_protocol.dart';

class CompleteOnboardingUseCase {
  final OnboardingRepositoryProtocol _repository;

  CompleteOnboardingUseCase(this._repository);

  Future<void> execute() async {
    try {
      await _repository.markOnboardingComplete();
    } catch (e) {
      print('❌ Erro ao marcar onboarding como concluído: $e');
      rethrow;
    }
  }
}
