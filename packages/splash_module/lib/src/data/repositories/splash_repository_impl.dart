import 'package:splash_module/src/domain/interfaces/auth_repository_protocol.dart';

import '../datasource/splash_user_local_datasource.dart';

class SplashRepositoryImpl implements UserLoggedInProtocol {
  final SplashUserLocalDataSourceProtocol datasource;

  SplashRepositoryImpl({required this.datasource});

  @override
  Future<bool> isUserLoggedIn() async {
    return await datasource.isUserLoggedIn();
  }
}
