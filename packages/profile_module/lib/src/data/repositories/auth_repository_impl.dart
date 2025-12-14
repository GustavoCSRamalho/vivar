// data/repositories/auth_repository_impl.dart

import 'package:profile_module/src/data/datasource/user/auth_datasource.dart';

import '../../domain/interfaces/auth_repository_protocol.dart';

/// Implementação do repositório de autenticação
/// Delega operações de dados para o datasource
/// Implementa múltiplos protocolos de autenticação
class AuthRepositoryImpl implements LogoutProtocol {
  final AuthDatasourceProtocol _datasource;

  AuthRepositoryImpl({required AuthDatasourceProtocol datasource})
    : _datasource = datasource;

  @override
  Future<void> logout() {
    return _datasource.deleteAllUsers();
  }
}
