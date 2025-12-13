// presentation/providers/login_provider.dart

import 'package:flutter/foundation.dart';
import '../../domain/entity/auth_user_entity.dart';
import '../../domain/usecases/login_with_apple_usecase.dart';
import '../../domain/usecases/login_with_email_usecase.dart';
import '../../domain/usecases/login_with_google_usecase.dart';
import '../../domain/usecases/send_password_reset_usecase.dart';

class LoginProvider with ChangeNotifier {
  final LoginWithEmailUseCase _loginWithEmailUseCase;
  final LoginWithGoogleUseCase _loginWithGoogleUseCase;
  final LoginWithAppleUseCase _loginWithAppleUseCase;
  final SendPasswordResetUseCase _sendPasswordResetUseCase;

  LoginProvider({
    required LoginWithEmailUseCase loginWithEmailUseCase,
    required LoginWithGoogleUseCase loginWithGoogleUseCase,
    required LoginWithAppleUseCase loginWithAppleUseCase,
    required SendPasswordResetUseCase sendPasswordResetUseCase,
  })  : _loginWithEmailUseCase = loginWithEmailUseCase,
        _loginWithGoogleUseCase = loginWithGoogleUseCase,
        _loginWithAppleUseCase = loginWithAppleUseCase,
        _sendPasswordResetUseCase = sendPasswordResetUseCase;

  AuthUserEntity? _currentUser;
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _error;

  AuthUserEntity? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get obscurePassword => _obscurePassword;
  String? get error => _error;

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  Future<bool> loginWithEmail(String email, String password) async {
    _setLoading(true);
    _error = null;

    try {
      _currentUser = await _loginWithEmailUseCase.execute(email, password);
      debugPrint('✅ Login realizado com sucesso');
      _setLoading(false);
      return true;
    } catch (e) {
      _error = _getErrorMessage(e);
      debugPrint('❌ Erro no login: $e');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> loginWithGoogle() async {
    _setLoading(true);
    _error = null;

    try {
      _currentUser = await _loginWithGoogleUseCase.execute();
      debugPrint('✅ Login com Google realizado');
      _setLoading(false);
      return true;
    } catch (e) {
      _error = 'Erro ao fazer login com Google';
      debugPrint('❌ Erro no login com Google: $e');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> loginWithApple() async {
    _setLoading(true);
    _error = null;

    try {
      _currentUser = await _loginWithAppleUseCase.execute();
      debugPrint('✅ Login com Apple realizado');
      _setLoading(false);
      return true;
    } catch (e) {
      _error = 'Erro ao fazer login com Apple';
      debugPrint('❌ Erro no login com Apple: $e');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> sendPasswordReset(String email) async {
    _setLoading(true);
    _error = null;

    try {
      await _sendPasswordResetUseCase.execute(email);
      debugPrint('✅ Email de recuperação enviado');
      _setLoading(false);
      return true;
    } catch (e) {
      _error = _getErrorMessage(e);
      debugPrint('❌ Erro ao enviar email: $e');
      _setLoading(false);
      return false;
    }
  }

  String _getErrorMessage(dynamic error) {
    final message = error.toString();
    if (message.contains('Email é obrigatório')) return 'Email é obrigatório';
    if (message.contains('Email inválido')) return 'Email inválido';
    if (message.contains('Senha é obrigatória')) return 'Senha é obrigatória';
    if (message.contains('Senha deve ter no mínimo'))
      return 'Senha deve ter no mínimo 6 caracteres';
    return 'Erro ao fazer login. Tente novamente.';
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
