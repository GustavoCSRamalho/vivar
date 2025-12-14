// data/datasources/map/map_datasource.dart

import 'package:core_module/core_module.dart';
import 'package:map_module/src/data/models/business_model.dart';
import 'package:sqflite/sqflite.dart';

/// Contrato abstrato para datasource de mapa
abstract class MapDatasourceProtocol {
  /// Busca todos os lugares para exibir no mapa
  Future<List<BusinessModel>> getBusinessesForMap();

  /// Busca lugares por categoria para o mapa
  Future<List<BusinessModel>> getBusinessesByCategory(String category);

  /// Busca lugares próximos para o mapa
  Future<List<BusinessModel>> getNearbyBusinessesForMap({
    required double latitude,
    required double longitude,
    required double radiusKm,
  });

  /// Busca lugares no mapa por texto
  Future<List<BusinessModel>> searchBusinessesOnMap(String query);
}

/// Implementação do datasource de mapa
/// Contém TODA a lógica de queries para lugares no mapa
class MapDatasourceImpl implements MapDatasourceProtocol {
  final DatabaseHelper _dbHelper;

  static const String _tableName = 'businesses';

  MapDatasourceImpl({DatabaseHelper? dbHelper})
    : _dbHelper = dbHelper ?? DatabaseHelper();

  Future<Database> get _database async => await _dbHelper.database;

  @override
  Future<List<BusinessModel>> getBusinessesForMap() async {
    try {
      final db = await _database;
      final List<Map<String, dynamic>> maps = await db.query(_tableName);
      return _mapListToModels(maps);
    } catch (e) {
      print('❌ Erro ao buscar lugares para o mapa: $e');
      return [];
    }
  }

  @override
  Future<List<BusinessModel>> getBusinessesByCategory(String category) async {
    try {
      final db = await _database;
      final List<Map<String, dynamic>> maps = await db.query(
        _tableName,
        where: 'category = ?',
        whereArgs: [category],
      );
      return _mapListToModels(maps);
    } catch (e) {
      print('❌ Erro ao buscar lugares por categoria no mapa: $e');
      return [];
    }
  }

  @override
  Future<List<BusinessModel>> getNearbyBusinessesForMap({
    required double latitude,
    required double longitude,
    required double radiusKm,
  }) async {
    try {
      final db = await _database;
      final query = _buildNearbyBusinessesQuery();

      final List<Map<String, dynamic>> maps = await db.rawQuery(query, [
        latitude,
        longitude,
        latitude,
        radiusKm,
      ]);

      return _mapListToModels(maps);
    } catch (e) {
      print('❌ Erro ao buscar lugares próximos no mapa: $e');
      return [];
    }
  }

  @override
  Future<List<BusinessModel>> searchBusinessesOnMap(String query) async {
    try {
      final db = await _database;
      final searchPattern = '%$query%';

      final List<Map<String, dynamic>> maps = await db.query(
        _tableName,
        where: 'name LIKE ? OR description LIKE ? OR category LIKE ?',
        whereArgs: [searchPattern, searchPattern, searchPattern],
      );

      return _mapListToModels(maps);
    } catch (e) {
      print('❌ Erro ao buscar lugares no mapa: $e');
      return [];
    }
  }

  /// Constrói a query SQL para busca de lugares próximos usando Haversine
  String _buildNearbyBusinessesQuery() {
    return '''
      SELECT *
      FROM (
        SELECT *,
          (6371 * acos(
            cos(radians(?)) * cos(radians(latitude)) *
            cos(radians(longitude) - radians(?)) +
            sin(radians(?)) * sin(radians(latitude))
          )) AS distance
        FROM $_tableName
      )
      WHERE distance < ?
      ORDER BY distance
    ''';
  }

  /// Converte lista de Maps para lista de PlaceModel
  List<BusinessModel> _mapListToModels(List<Map<String, dynamic>> maps) {
    return maps.map((map) => BusinessModel.fromMap(map)).toList();
  }
}
