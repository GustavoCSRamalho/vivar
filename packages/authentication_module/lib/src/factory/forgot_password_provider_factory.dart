// presentation/providers/forgot_password_provider_factory.dart

import 'package:vivar/screens/auth/data/datasource/auth_datasource.dart';
import 'package:vivar/screens/auth/data/repositories/auth_repository_impl.dart';
import 'package:vivar/screens/auth/domain/usecases/send_password_reset_usecase.dart';
import 'package:vivar/screens/auth/domain/usecases/verify_email_exists_usecase.dart';
import 'package:vivar/screens/auth/presentation/forgot_password/forgot_password_provider.dart';

class ForgotPasswordProviderFactory {
  static ForgotPasswordProvider create() {
    final datasource = AuthDatasource();
    final repository = AuthRepositoryImpl(datasource: datasource);

    final sendPasswordResetUseCase = SendPasswordResetUseCase(repository);
    final verifyEmailExistsUseCase = VerifyEmailExistsUseCase(repository);

    return ForgotPasswordProvider(
      sendPasswordResetUseCase: sendPasswordResetUseCase,
      verifyEmailExistsUseCase: verifyEmailExistsUseCase,
    );
  }
}
