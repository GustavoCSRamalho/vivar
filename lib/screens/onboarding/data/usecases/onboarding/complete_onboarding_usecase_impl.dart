// data/usecases/onboarding/complete_onboarding_usecase_impl.dart

import 'package:vivar/screens/onboarding/domain/repositories/onboarding_repository_protocol.dart';
import 'package:vivar/screens/onboarding/domain/usecases/onboarding/complete_onboarding_usecase.dart';

class CompleteOnboardingUseCaseImpl implements CompleteOnboardingUseCase {
  final OnboardingRepositoryProtocol _repository;

  CompleteOnboardingUseCaseImpl(this._repository);

  @override
  Future<void> execute() async {
    try {
      await _repository.markOnboardingComplete();
    } catch (e) {
      print('❌ Erro ao completar onboarding: $e');
      rethrow;
    }
  }
}
