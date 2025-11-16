// presentation/providers/splash_provider.dart

import 'package:flutter/foundation.dart';
import 'package:vivar/screens/splash/domain/usecases/splash/check_authentication_usecase.dart';
import 'package:vivar/screens/splash/domain/usecases/splash/initialize_app_usecase.dart';

enum SplashState { initial, loading, authenticated, unauthenticated, error }

class SplashProvider with ChangeNotifier {
  final CheckAuthenticationUseCase _checkAuthenticationUseCase;
  final InitializeAppUseCase _initializeAppUseCase;

  SplashProvider({
    required CheckAuthenticationUseCase checkAuthenticationUseCase,
    required InitializeAppUseCase initializeAppUseCase,
  }) : _checkAuthenticationUseCase = checkAuthenticationUseCase,
       _initializeAppUseCase = initializeAppUseCase;

  SplashState _state = SplashState.initial;
  String? _error;

  SplashState get state => _state;
  String? get error => _error;

  Future<void> initialize() async {
    _setState(SplashState.loading);
    _error = null;

    try {
      await _initializeAppUseCase.execute();

      final isAuthenticated = await _checkAuthenticationUseCase.execute();

      if (isAuthenticated) {
        _setState(SplashState.authenticated);
        debugPrint('✅ Usuário autenticado');
      } else {
        _setState(SplashState.unauthenticated);
        debugPrint('⚠️ Usuário não autenticado');
      }
    } catch (e) {
      _error = 'Erro ao inicializar: $e';
      _setState(SplashState.error);
      debugPrint('❌ Erro na splash: $e');
    }
  }

  void _setState(SplashState newState) {
    _state = newState;
    notifyListeners();
  }
}
