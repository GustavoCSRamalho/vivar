// data/datasources/discover/discover_datasource_impl.dart

// data/datasources/discover/discover_datasource_protocol.dart

import 'package:core_module/core_module.dart';
import 'package:discover_module/src/data/model/business_model.dart';
import 'package:sqflite/sqflite.dart';

/// Contrato abstrato para datasource de descoberta de lugares
/// Define os métodos que devem ser implementados para gerenciar coleções e lugares em destaque
abstract class DiscoverDatasourceProtocol {
  /// Busca lugares em alta (trending)
  /// Ordenados por número de reviews (mais populares)
  ///
  /// Retorna lista de [PlaceModel] em alta (máximo 12)
  Future<List<BusinessModel>> getTrendingBusinesses();

  /// Busca lugares próximos ao usuário
  /// Ordenados por distância (mais próximos primeiro)
  ///
  /// Retorna lista de [PlaceModel] próximos (máximo 8)
  Future<List<BusinessModel>> getNearYouBusinesses();

  /// Busca lugares mais bem avaliados
  /// Filtra lugares com rating >= 4.5
  /// Ordenados por rating e número de reviews
  ///
  /// Retorna lista de [PlaceModel] top rated (máximo 15)
  Future<List<BusinessModel>> getTopRatedBusinesses();

  /// Busca lugares recém adicionados
  /// Ordenados por data de criação (mais recentes primeiro)
  ///
  /// Retorna lista de [PlaceModel] novos (máximo 6)
  Future<List<BusinessModel>> getNewBusinesses();
}

/// Implementação do datasource de descoberta
/// Contém TODA a lógica de queries para buscar lugares em destaque
/// Gerencia diferentes coleções: trending, nearby, top rated, new
class DiscoverDatasourceImpl implements DiscoverDatasourceProtocol {
  final DatabaseHelper _dbHelper;

  static const String _tableName = 'businesses';
  static const int _trendingLimit = 12;
  static const int _nearbyLimit = 8;
  static const int _topRatedLimit = 15;
  static const int _newBusinessesLimit = 6;
  static const double _minRatingForTopRated = 4.5;

  DiscoverDatasourceImpl({DatabaseHelper? dbHelper})
    : _dbHelper = dbHelper ?? DatabaseHelper();

  Future<Database> get _database async => await _dbHelper.database;

  @override
  Future<List<BusinessModel>> getTrendingBusinesses() async {
    try {
      final db = await _database;
      final List<Map<String, dynamic>> maps = await db.query(
        _tableName,
        orderBy: 'reviews_count DESC',
        limit: _trendingLimit,
      );
      return _mapListToModels(maps);
    } catch (e) {
      print('❌ Erro ao buscar lugares em alta: $e');
      return [];
    }
  }

  @override
  Future<List<BusinessModel>> getNearYouBusinesses() async {
    try {
      final db = await _database;
      final List<Map<String, dynamic>> maps = await db.query(
        _tableName,
        orderBy: 'distance ASC',
        limit: _nearbyLimit,
      );
      return _mapListToModels(maps);
    } catch (e) {
      print('❌ Erro ao buscar lugares próximos: $e');
      return [];
    }
  }

  @override
  Future<List<BusinessModel>> getTopRatedBusinesses() async {
    try {
      final db = await _database;
      final List<Map<String, dynamic>> maps = await db.query(
        _tableName,
        where: 'rating >= ?',
        whereArgs: [_minRatingForTopRated],
        orderBy: 'rating DESC, reviews_count DESC',
        limit: _topRatedLimit,
      );
      return _mapListToModels(maps);
    } catch (e) {
      print('❌ Erro ao buscar lugares mais bem avaliados: $e');
      return [];
    }
  }

  @override
  Future<List<BusinessModel>> getNewBusinesses() async {
    try {
      final db = await _database;
      final List<Map<String, dynamic>> maps = await db.query(
        _tableName,
        orderBy: 'created_at DESC',
        limit: _newBusinessesLimit,
      );
      return _mapListToModels(maps);
    } catch (e) {
      print('❌ Erro ao buscar lugares novos: $e');
      return [];
    }
  }

  /// Converte lista de Maps para lista de PlaceModel
  List<BusinessModel> _mapListToModels(List<Map<String, dynamic>> maps) {
    return maps.map((map) => BusinessModel.fromMap(map)).toList();
  }
}
