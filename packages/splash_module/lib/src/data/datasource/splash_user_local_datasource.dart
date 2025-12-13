import 'package:core_module/core_module.dart';
import 'package:sqflite/sqflite.dart';

abstract class SplashUserLocalDataSourceProtocol {
  Future<bool> isUserLoggedIn();
}

class SplashUserLocalDataSourceImpl
    implements SplashUserLocalDataSourceProtocol {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final String _userTableName = "users";

  Future<Database> get _database async => await _dbHelper.database;

  @override
  Future<bool> isUserLoggedIn() async {
    try {
      final db = await _database;
      final result = await db.query(_userTableName, limit: 1);
      return result.isNotEmpty;
    } catch (e) {
      print("❌ Erro no datasource: $e");
      return false;
    }
  }
}
