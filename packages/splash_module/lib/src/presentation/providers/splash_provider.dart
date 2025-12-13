// presentation/providers/splash_provider.dart

import 'package:flutter/foundation.dart';
import 'package:splash_module/src/domain/usecase/check_authentication_usecase.dart';
import 'package:splash_module/src/domain/usecase/initialize_app_usecase.dart';

enum SplashState { initial, loading, authenticated, unauthenticated, error }

class SplashProvider with ChangeNotifier {
  final UserLoggedInUseCase _userLoggedInUseCase;
  final InitializeAppUseCase _initializeAppUseCase;

  SplashProvider({
    required UserLoggedInUseCase userLoggedInUseCase,
    required InitializeAppUseCase initializeAppUseCase,
  })  : _userLoggedInUseCase = userLoggedInUseCase,
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

      final isAuthenticated = await _userLoggedInUseCase.execute();

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
