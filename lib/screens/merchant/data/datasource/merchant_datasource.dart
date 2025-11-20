// data/datasources/merchant/merchant_datasource.dart

import 'package:sqflite/sqflite.dart';
import 'package:vivar/core/database/database_helper.dart';
import 'package:vivar/domain/entity/merchant/merchant_entity.dart';
import 'dart:convert';

/// Contrato abstrato para datasource de comerciantes
abstract class MerchantDatasourceProtocol {
  /// Registra um novo comerciante
  Future<void> registerMerchant(MerchantEntity merchant);

  /// Busca comerciante por ID
  Future<MerchantEntity?> getMerchantById(String merchantId);

  /// Busca comerciantes de um usuário
  Future<List<MerchantEntity>> getUserMerchants(String userId);
}

/// Implementação do datasource de comerciantes
/// Contém TODA a lógica de acesso ao banco de dados SQLite
class MerchantDatasourceImpl implements MerchantDatasourceProtocol {
  final DatabaseHelper _dbHelper;

  static const String _tableName = 'merchants';

  MerchantDatasourceImpl({DatabaseHelper? dbHelper})
    : _dbHelper = dbHelper ?? DatabaseHelper();

  Future<Database> get _database async => await _dbHelper.database;

  @override
  Future<void> registerMerchant(MerchantEntity merchant) async {
    try {
      final db = await _database;

      await db.insert(
        _tableName,
        _entityToMap(merchant),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('❌ Erro ao registrar comerciante: $e');
      rethrow;
    }
  }

  @override
  Future<MerchantEntity?> getMerchantById(String merchantId) async {
    try {
      final db = await _database;
      final List<Map<String, dynamic>> maps = await db.query(
        _tableName,
        where: 'id = ?',
        whereArgs: [merchantId],
        limit: 1,
      );

      if (maps.isEmpty) return null;

      return _mapToEntity(maps.first);
    } catch (e) {
      print('❌ Erro ao buscar comerciante por ID: $e');
      return null;
    }
  }

  @override
  Future<List<MerchantEntity>> getUserMerchants(String userId) async {
    try {
      final db = await _database;
      final List<Map<String, dynamic>> maps = await db.query(
        _tableName,
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'created_at DESC',
      );

      return maps.map(_mapToEntity).toList();
    } catch (e) {
      print('❌ Erro ao buscar comerciantes do usuário: $e');
      return [];
    }
  }

  /// Converte MerchantEntity para Map para inserção no banco
  Map<String, dynamic> _entityToMap(MerchantEntity entity) {
    return {
      'id': entity.id,
      'name': entity.name,
      'category': entity.category,
      'address': entity.address,
      'phone': entity.phone,
      'email': entity.email,
      'description': entity.description,
      'images': jsonEncode(entity.images),
      'schedule': jsonEncode(entity.schedule),
      'amenities': jsonEncode(entity.amenities),
      'is_whatsapp': entity.isWhatsapp ? 1 : 0,
      'status': entity.status,
      'created_at': entity.createdAt.toIso8601String(),
    };
  }

  /// Converte Map do banco para MerchantEntity
  MerchantEntity _mapToEntity(Map<String, dynamic> map) {
    return MerchantEntity(
      id: map['id'] as String,
      name: map['name'] as String,
      category: map['category'] as String,
      address: map['address'] as String,
      phone: map['phone'] as String,
      email: map['email'] as String,
      description: map['description'] as String,
      images: List<String>.from(jsonDecode(map['images'] as String)),
      schedule: Map<String, String>.from(jsonDecode(map['schedule'] as String)),
      amenities: List<String>.from(jsonDecode(map['amenities'] as String)),
      isWhatsapp: (map['is_whatsapp'] as int) == 1,
      status: map['status'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}
