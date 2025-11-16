// data/usecases/splash/initialize_app_usecase_impl.dart

import 'package:vivar/core/database/database_helper.dart';
import 'package:vivar/screens/splash/domain/usecases/splash/initialize_app_usecase.dart';

class InitializeAppUseCaseImpl implements InitializeAppUseCase {
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
