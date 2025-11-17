// domain/repositories/onboarding_repository_protocol.dart

abstract class OnboardingRepositoryProtocol {
  Future<void> markOnboardingComplete();
  Future<bool> hasCompletedOnboarding();
}
