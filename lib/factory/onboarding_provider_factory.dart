// presentation/providers/onboarding_provider_factory.dart

import 'package:vivar/domain/usecases/onboarding/complete_onboarding_interface.dart';
import 'package:vivar/screens/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:vivar/screens/onboarding/data/datasource/onboarding_datasource.dart';
import 'package:vivar/screens/onboarding/presentation/providers/onboarding_provider.dart';

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
