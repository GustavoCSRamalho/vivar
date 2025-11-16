// domain/repositories/auth_repository_protocol.dart

abstract class AuthRepositoryProtocol {
  Future<bool> isUserLoggedIn();
  Future<String?> getCurrentUserId();
}
