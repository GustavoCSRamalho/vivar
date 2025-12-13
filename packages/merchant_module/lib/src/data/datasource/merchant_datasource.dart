// data/datasources/merchant/merchant_local_datasource_impl.dart

import 'package:core_module/core_module.dart';
import 'package:merchant_module/src/data/models/business_model.dart';
import 'package:sqflite/sqflite.dart';

// data/datasources/merchant/merchant_local_datasource_protocol.dart

abstract class MerchantLocalDatasourceProtocol {
  Future<void> registerMerchant(BusinessModel merchant);
  Future<BusinessModel?> getMerchantById(String merchantId);
  Future<List<BusinessModel>> getUserMerchants(String userId);
  Future<void> markAsPendingSync(String merchantId);
  Future<List<BusinessModel>> getPendingMerchants();
  Future<void> updateMerchant(BusinessModel merchant);
}

class MerchantLocalDatasourceImpl implements MerchantLocalDatasourceProtocol {
  final DatabaseHelper _dbHelper;
  static const String _tableName = 'businesses';

  MerchantLocalDatasourceImpl({DatabaseHelper? dbHelper})
    : _dbHelper = dbHelper ?? DatabaseHelper();

  Future<Database> get _database async => await _dbHelper.database;

  @override
  Future<void> registerMerchant(BusinessModel merchant) async {
    try {
      final db = await _database;
      await db.insert(
        _tableName,
        merchant.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('❌ Erro ao registrar comerciante: $e');
      rethrow;
    }
  }

  @override
  Future<BusinessModel?> getMerchantById(String merchantId) async {
    try {
      final db = await _database;
      final List<Map<String, dynamic>> maps = await db.query(
        _tableName,
        where: 'id = ?',
        whereArgs: [merchantId],
        limit: 1,
      );

      if (maps.isEmpty) return null;
      return BusinessModel.fromMap(maps.first);
    } catch (e) {
      print('❌ Erro ao buscar comerciante por ID: $e');
      return null;
    }
  }

  @override
  Future<List<BusinessModel>> getUserMerchants(String userId) async {
    try {
      final db = await _database;
      final List<Map<String, dynamic>> maps = await db.query(
        _tableName,
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'created_at DESC',
      );

      return maps.map((map) => BusinessModel.fromMap(map)).toList();
    } catch (e) {
      print('❌ Erro ao buscar comerciantes do usuário: $e');
      return [];
    }
  }

  @override
  Future<void> markAsPendingSync(String merchantId) async {
    try {
      final db = await _database;
      await db.update(
        _tableName,
        {'synced': 0},
        where: 'id = ?',
        whereArgs: [merchantId],
      );
    } catch (e) {
      print('❌ Erro ao marcar comerciante como pendente: $e');
      rethrow;
    }
  }

  @override
  Future<List<BusinessModel>> getPendingMerchants() async {
    try {
      final db = await _database;
      final List<Map<String, dynamic>> maps = await db.query(
        _tableName,
        where: 'synced = ?',
        whereArgs: [0],
        orderBy: 'updated_at ASC',
      );

      return maps.map((map) => BusinessModel.fromMap(map)).toList();
    } catch (e) {
      print('❌ Erro ao buscar comerciantes pendentes: $e');
      return [];
    }
  }

  @override
  Future<void> updateMerchant(BusinessModel merchant) async {
    try {
      final db = await _database;
      await db.update(
        _tableName,
        merchant.toMap(),
        where: 'id = ?',
        whereArgs: [merchant.id],
      );
    } catch (e) {
      print('❌ Erro ao atualizar comerciante: $e');
      rethrow;
    }
  }
}
