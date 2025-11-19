// data/usecases/splash/initialize_app_usecase_impl.dart

import 'package:vivar/core/database/database_helper.dart';
import 'package:vivar/domain/interface/initialize/initialize_app_protocol.dart';

class InitializeAppUseCase implements InitializeAppProtocol {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  Future<void> execute() async {
    try {
      await _dbHelper.database;
      await Future.delayed(Duration(milliseconds: 500));
      print('✅ App inicializado');
    } catch (e) {
      print('❌ Erro ao inicializar app: $e');
      rethrow;
    }
  }
}
