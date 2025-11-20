// presentation/providers/register_provider.dart

import 'package:flutter/foundation.dart';
import 'package:vivar/domain/entity/auth/auth_user_entity.dart';
import 'package:vivar/domain/entity/register/register_user_entity.dart';
import 'package:vivar/domain/usecases/auth/login_with_apple_usecase.dart';
import 'package:vivar/domain/usecases/auth/login_with_google_usecase.dart';
import 'package:vivar/domain/usecases/auth/register_user_usecase.dart';

class RegisterProvider with ChangeNotifier {
  final RegisterUserUseCase _registerUserUseCase;
  final LoginWithGoogleUseCase _loginWithGoogleUseCase;
  final LoginWithAppleUseCase _loginWithAppleUseCase;

  RegisterProvider({
    required RegisterUserUseCase registerUserUseCase,
    required LoginWithGoogleUseCase loginWithGoogleUseCase,
    required LoginWithAppleUseCase loginWithAppleUseCase,
  }) : _registerUserUseCase = registerUserUseCase,
       _loginWithGoogleUseCase = loginWithGoogleUseCase,
       _loginWithAppleUseCase = loginWithAppleUseCase;

  AuthUserEntity? _currentUser;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;
  String? _error;

  AuthUserEntity? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get obscurePassword => _obscurePassword;
  bool get obscureConfirmPassword => _obscureConfirmPassword;
  bool get acceptTerms => _acceptTerms;
  String? get error => _error;
  bool get canRegister => _acceptTerms;

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _obscureConfirmPassword = !_obscureConfirmPassword;
    notifyListeners();
  }

  void setAcceptTerms(bool value) {
    _acceptTerms = value;
    notifyListeners();
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    String? phone,
  }) async {
    _setLoading(true);
    _error = null;

    // Validar confirmação de senha
    if (password != confirmPassword) {
      _error = 'As senhas não coincidem';
      _setLoading(false);
      return false;
    }

    if (!_acceptTerms) {
      _error = 'Você precisa aceitar os termos de uso';
      _setLoading(false);
      return false;
    }

    try {
      final registerData = RegisterUserEntity(
        name: name,
        email: email,
        password: password,
        phone: phone,
      );

      _currentUser = await _registerUserUseCase.execute(registerData);
      debugPrint('✅ Cadastro realizado com sucesso');
      _setLoading(false);
      return true;
    } catch (e) {
      _error = _getErrorMessage(e);
      debugPrint('❌ Erro no cadastro: $e');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> registerWithGoogle() async {
    _setLoading(true);
    _error = null;

    try {
      _currentUser = await _loginWithGoogleUseCase.execute();
      debugPrint('✅ Cadastro com Google realizado');
      _setLoading(false);
      return true;
    } catch (e) {
      _error = 'Erro ao fazer cadastro com Google';
      debugPrint('❌ Erro no cadastro com Google: $e');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> registerWithApple() async {
    _setLoading(true);
    _error = null;

    try {
      _currentUser = await _loginWithAppleUseCase.execute();
      debugPrint('✅ Cadastro com Apple realizado');
      _setLoading(false);
      return true;
    } catch (e) {
      _error = 'Erro ao fazer cadastro com Apple';
      debugPrint('❌ Erro no cadastro com Apple: $e');
      _setLoading(false);
      return false;
    }
  }

  String _getErrorMessage(dynamic error) {
    final message = error.toString();
    if (message.contains('Nome é obrigatório')) return 'Nome é obrigatório';
    if (message.contains('Nome deve ter no mínimo'))
      return 'Nome deve ter no mínimo 3 caracteres';
    if (message.contains('Email é obrigatório')) return 'Email é obrigatório';
    if (message.contains('Email inválido')) return 'Email inválido';
    if (message.contains('Senha é obrigatória')) return 'Senha é obrigatória';
    if (message.contains('Senha deve ter no mínimo'))
      return 'Senha deve ter no mínimo 6 caracteres';
    if (message.contains('já está cadastrado'))
      return 'Este email já está cadastrado';
    return 'Erro ao fazer cadastro. Tente novamente.';
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
