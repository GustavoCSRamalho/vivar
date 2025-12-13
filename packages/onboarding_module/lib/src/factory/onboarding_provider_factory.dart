// presentation/providers/onboarding_provider_factory.dart

import 'package:onboarding_module/src/data/domain/usecases/complete_onboarding_interface.dart';
import '../data/repositories/onboarding_repository_impl.dart';
import '../data/datasource/onboarding_datasource.dart';
import '../presentation/providers/onboarding_provider.dart';

class OnboardingProviderFactory {
  static OnboardingProvider create() {
    final datasource = OnboardingDatasource();
    final repository = OnboardingRepositoryImpl(datasource: datasource);
    final completeOnboardingUseCase = CompleteOnboardingUseCase(repository);

    return OnboardingProvider(
      completeOnboardingUseCase: completeOnboardingUseCase,
    );
  }
}
