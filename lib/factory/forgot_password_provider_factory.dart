// presentation/providers/forgot_password_provider_factory.dart

import 'package:vivar/screens/auth/data/repositories/auth_repository_impl.dart';
import 'package:vivar/domain/usecases/auth/send_password_reset_usecase.dart';
import 'package:vivar/domain/usecases/auth/verify_email_exists_usecase.dart';
import 'package:vivar/screens/auth/presentation/providers/forgot_password_provider.dart';

class ForgotPasswordProviderFactory {
  static ForgotPasswordProvider create() {
    final repository = AuthRepositoryImpl();

    final sendPasswordResetUseCase = SendPasswordResetUseCase(repository);
    final verifyEmailExistsUseCase = VerifyEmailExistsUseCase(repository);

    return ForgotPasswordProvider(
      sendPasswordResetUseCase: sendPasswordResetUseCase,
      verifyEmailExistsUseCase: verifyEmailExistsUseCase,
    );
  }
}
