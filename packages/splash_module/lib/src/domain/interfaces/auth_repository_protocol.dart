// domain/repositories/auth_repository_protocol.dart

/// Verifica se há sessão ativa
abstract class UserLoggedInProtocol {
  Future<bool> isUserLoggedIn();
}
