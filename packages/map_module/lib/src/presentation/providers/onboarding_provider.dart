// presentation/providers/onboarding_provider.dart

import 'package:flutter/foundation.dart';
import 'package:onboarding_module/src/data/domain/usecases/complete_onboarding_interface.dart';

class OnboardingProvider with ChangeNotifier {
  final CompleteOnboardingUseCase _completeOnboardingUseCase;

  OnboardingProvider({
    required CompleteOnboardingUseCase completeOnboardingUseCase,
  }) : _completeOnboardingUseCase = completeOnboardingUseCase;

  int _currentPage = 0;
  bool _isCompleting = false;

  int get currentPage => _currentPage;
  bool get isCompleting => _isCompleting;
  bool get isLastPage => _currentPage == 2;

  void setPage(int page) {
    _currentPage = page;
    notifyListeners();
  }

  void nextPage() {
    if (_currentPage < 2) {
      _currentPage++;
      notifyListeners();
    }
  }

  void previousPage() {
    if (_currentPage > 0) {
      _currentPage--;
      notifyListeners();
    }
  }

  Future<void> completeOnboarding() async {
    _isCompleting = true;
    notifyListeners();

    try {
      await _completeOnboardingUseCase.execute();
      debugPrint('✅ Onboarding completo');
    } catch (e) {
      debugPrint('❌ Erro ao completar onboarding: $e');
      rethrow;
    } finally {
      _isCompleting = false;
      notifyListeners();
    }
  }
}
