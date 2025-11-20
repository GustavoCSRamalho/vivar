import 'package:vivar/screens/splash/data/datasource/user_local_datasource.dart';
import '../../../../domain/interface/auth/auth_repository_protocol.dart';

class SplashRepositoryImpl implements UserLoggedInProtocol {
  final UserLocalDataSourceProtocol datasource;

  SplashRepositoryImpl({required this.datasource});

  @override
  Future<bool> isUserLoggedIn() async {
    return await datasource.isUserLoggedIn();
  }
}
