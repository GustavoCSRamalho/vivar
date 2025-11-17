// presentation/providers/onboarding_provider_factory.dart

import 'package:vivar/screens/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:vivar/screens/onboarding/data/usecases/onboarding/complete_onboarding_usecase_impl.dart';
import 'package:vivar/screens/onboarding/presentation/providers/onboarding_provider.dart';

class OnboardingProviderFactory {
  static OnboardingProvider create() {
    final repository = OnboardingRepositoryImpl();
    final completeOnboardingUseCase = CompleteOnboardingUseCaseImpl(repository);

    return OnboardingProvider(
      completeOnboardingUseCase: completeOnboardingUseCase,
    );
  }
}
