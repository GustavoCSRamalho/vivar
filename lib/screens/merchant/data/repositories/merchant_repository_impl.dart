// data/repositories/merchant_repository_impl.dart

import 'package:sqflite/sqflite.dart';
import 'package:vivar/core/database/database_helper.dart';
import 'package:vivar/screens/merchant/domain/entities/merchant_entity.dart';
import 'dart:convert';

import 'package:vivar/screens/merchant/domain/repositories/merchant_repository_protocol.dart';

class MerchantRepositoryImpl implements MerchantRepositoryProtocol {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final String _merchantTableName = 'merchants';

  Future<Database> get _database async => await _dbHelper.database;

  @override
  Future<void> registerMerchant(MerchantEntity merchant) async {
    final db = await _database;

    await db.insert(_merchantTableName, {
      'id': merchant.id,
      'name': merchant.name,
      'category': merchant.category,
      'address': merchant.address,
      'phone': merchant.phone,
      'email': merchant.email,
      'description': merchant.description,
      'images': jsonEncode(merchant.images),
      'schedule': jsonEncode(merchant.schedule),
      'amenities': jsonEncode(merchant.amenities),
      'is_whatsapp': merchant.isWhatsapp ? 1 : 0,
      'status': merchant.status,
      'created_at': merchant.createdAt.toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<MerchantEntity?> getMerchantById(String merchantId) async {
    final db = await _database;
    final List<Map<String, dynamic>> maps = await db.query(
      _merchantTableName,
      where: 'id = ?',
      whereArgs: [merchantId],
      limit: 1,
    );

    if (maps.isEmpty) return null;

    return _mapToEntity(maps.first);
  }

  @override
  Future<List<MerchantEntity>> getUserMerchants(String userId) async {
    final db = await _database;
    final List<Map<String, dynamic>> maps = await db.query(
      _merchantTableName,
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );

    return maps.map((map) => _mapToEntity(map)).toList();
  }

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
