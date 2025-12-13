// presentation/providers/forgot_password_provider.dart

import 'package:flutter/foundation.dart';
import '../../domain/usecases/send_password_reset_usecase.dart';
import '../../domain/usecases/verify_email_exists_usecase.dart';

enum ForgotPasswordStep { enterEmail, emailSent }

class ForgotPasswordProvider with ChangeNotifier {
  final SendPasswordResetUseCase _sendPasswordResetUseCase;
  final VerifyEmailExistsUseCase _verifyEmailExistsUseCase;

  ForgotPasswordProvider({
    required SendPasswordResetUseCase sendPasswordResetUseCase,
    required VerifyEmailExistsUseCase verifyEmailExistsUseCase,
  })  : _sendPasswordResetUseCase = sendPasswordResetUseCase,
        _verifyEmailExistsUseCase = verifyEmailExistsUseCase;

  ForgotPasswordStep _currentStep = ForgotPasswordStep.enterEmail;
  bool _isLoading = false;
  String? _error;
  String? _sentEmail;

  ForgotPasswordStep get currentStep => _currentStep;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get sentEmail => _sentEmail;

  Future<bool> sendPasswordReset(String email) async {
    _setLoading(true);
    _error = null;

    try {
      // Verificar se o email existe
      final emailExists = await _verifyEmailExistsUseCase.execute(email);

      if (!emailExists) {
        _error = 'Este email não está cadastrado';
        _setLoading(false);
        return false;
      }

      // Enviar email de recuperação
      await _sendPasswordResetUseCase.execute(email);

      _sentEmail = email;
      _currentStep = ForgotPasswordStep.emailSent;
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

  Future<bool> resendEmail() async {
    if (_sentEmail == null) return false;

    _setLoading(true);
    _error = null;

    try {
      await _sendPasswordResetUseCase.execute(_sentEmail!);
      debugPrint('✅ Email reenviado');
      _setLoading(false);
      return true;
    } catch (e) {
      _error = 'Erro ao reenviar email';
      debugPrint('❌ Erro ao reenviar email: $e');
      _setLoading(false);
      return false;
    }
  }

  void reset() {
    _currentStep = ForgotPasswordStep.enterEmail;
    _error = null;
    _sentEmail = null;
    notifyListeners();
  }

  String _getErrorMessage(dynamic error) {
    final message = error.toString();
    if (message.contains('Email é obrigatório')) return 'Email é obrigatório';
    if (message.contains('Email inválido')) return 'Email inválido';
    if (message.contains('não está cadastrado'))
      return 'Este email não está cadastrado';
    return 'Erro ao enviar email. Tente novamente.';
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
