// data/datasources/place/place_datasource_impl.dart

// data/datasources/place/place_datasource_protocol.dart

import 'package:vivar/models/business_model.dart';
import 'package:vivar/models/place_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vivar/core/database/database_helper.dart';

/// Contrato abstrato para datasource de lugares
/// Define os métodos que devem ser implementados para gerenciar dados de lugares
abstract class BusinessesDatasourceProtocol {
  /// Busca todos os lugares cadastrados
  ///
  /// Retorna lista de [PlaceModel]
  Future<List<BusinessModel>> getAllBusinesses();

  /// Busca lugares próximos a uma coordenada geográfica
  ///
  /// [latitude] - Latitude do ponto de referência
  /// [longitude] - Longitude do ponto de referência
  /// [radiusKm] - Raio de busca em quilômetros
  /// Retorna lista de lugares ordenados por distância
  Future<List<BusinessModel>> getNearbyBusinesses({
    required double latitude,
    required double longitude,
    required double radiusKm,
  });

  /// Busca lugares por categoria
  ///
  /// [category] - Categoria do lugar (ex: "restaurante", "bar", "academia")
  /// Retorna lista de [PlaceModel] da categoria especificada
  Future<List<BusinessModel>> getBusinessesByCategory(String category);

  /// Busca lugares por texto
  ///
  /// [query] - Texto de busca (procura em nome, descrição e categoria)
  /// Retorna lista de [PlaceModel] que correspondem à busca
  Future<List<BusinessModel>> searchBusinesses(String query);

  /// Busca um lugar específico pelo ID
  ///
  /// [id] - ID do lugar
  /// Retorna [PlaceModel] se encontrado, ou [null] caso contrário
  Future<BusinessModel?> getBusinessesById(String id);

  /// Busca lugares que oferecem desconto
  ///
  /// Retorna lista de [PlaceModel] com desconto ativo
  Future<List<BusinessModel>> getBusinessesWithDiscount();

  /// Busca os lugares mais bem avaliados
  ///
  /// [limit] - Número máximo de lugares a retornar (padrão: 10)
  /// Retorna lista de [PlaceModel] ordenados por avaliação
  Future<List<BusinessModel>> getTopRatedBusinesses({int limit = 10});

  /// Busca lugares com filtros múltiplos
  ///
  /// [categories] - Lista de categorias para filtrar
  /// [priceRange] - Faixa de preço (ex: "$", "$$", "$$$")
  /// [minRating] - Avaliação mínima
  /// [amenities] - Lista de comodidades desejadas
  /// [openNow] - Se deve filtrar apenas lugares abertos
  /// Retorna lista de [PlaceModel] que correspondem aos filtros
  Future<List<BusinessModel>> getFilteredBusinesses({
    List<String>? categories,
    String? priceRange,
    double? minRating,
    List<String>? amenities,
    bool? openNow,
  });
}

/// Implementação do datasource de lugares
/// Contém TODA a lógica de acesso ao banco de dados SQLite
/// Gerencia queries complexas incluindo busca geográfica e filtros múltiplos
class BusinessesDatasourceImpl implements BusinessesDatasourceProtocol {
  final DatabaseHelper _dbHelper;

  static const String _tableName = 'businesses';

  BusinessesDatasourceImpl({DatabaseHelper? dbHelper})
    : _dbHelper = dbHelper ?? DatabaseHelper();

  Future<Database> get _database async => await _dbHelper.database;

  @override
  Future<List<BusinessModel>> getAllBusinesses() async {
    try {
      final db = await _database;
      final List<Map<String, dynamic>> maps = await db.query(_tableName);
      return _mapListToModels(maps);
    } catch (e) {
      print('❌ Erro ao buscar todos os lugares: $e');
      return [];
    }
  }

  @override
  Future<List<BusinessModel>> getNearbyBusinesses({
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
      print('❌ Erro ao buscar lugares próximos: $e');
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
      print('❌ Erro ao buscar lugares por categoria: $e');
      return [];
    }
  }

  @override
  Future<List<BusinessModel>> searchBusinesses(String query) async {
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
      print('❌ Erro ao buscar lugares: $e');
      return [];
    }
  }

  @override
  Future<BusinessModel?> getBusinessesById(String id) async {
    try {
      final db = await _database;
      final List<Map<String, dynamic>> maps = await db.query(
        _tableName,
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (maps.isEmpty) return null;

      return BusinessModel.fromMap(maps.first);
    } catch (e) {
      print('❌ Erro ao buscar lugar por ID: $e');
      return null;
    }
  }

  @override
  Future<List<BusinessModel>> getBusinessesWithDiscount() async {
    try {
      final db = await _database;
      final List<Map<String, dynamic>> maps = await db.query(
        _tableName,
        where: 'discount_percentage IS NOT NULL AND discount_percentage > 0',
      );
      return _mapListToModels(maps);
    } catch (e) {
      print('❌ Erro ao buscar lugares com desconto: $e');
      return [];
    }
  }

  @override
  Future<List<BusinessModel>> getTopRatedBusinesses({int limit = 10}) async {
    try {
      final db = await _database;
      final List<Map<String, dynamic>> maps = await db.query(
        _tableName,
        orderBy: 'rating DESC, reviews_count DESC',
        limit: limit,
      );
      return _mapListToModels(maps);
    } catch (e) {
      print('❌ Erro ao buscar lugares mais bem avaliados: $e');
      return [];
    }
  }

  @override
  Future<List<BusinessModel>> getFilteredBusinesses({
    List<String>? categories,
    String? priceRange,
    double? minRating,
    List<String>? amenities,
    bool? openNow,
  }) async {
    try {
      final db = await _database;

      final filterResult = _buildFilterQuery(
        categories: categories,
        priceRange: priceRange,
        minRating: minRating,
        openNow: openNow,
      );

      final List<Map<String, dynamic>> maps = await db.query(
        _tableName,
        where: filterResult.where,
        whereArgs: filterResult.whereArgs,
      );

      return _mapListToModels(maps);
    } catch (e) {
      print('❌ Erro ao buscar lugares filtrados: $e');
      return [];
    }
  }

  /// Constrói a query SQL para busca de lugares próximos usando fórmula de Haversine
  /// Calcula a distância em quilômetros entre dois pontos geográficos
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

  /// Constrói dinamicamente a cláusula WHERE e seus argumentos para filtros múltiplos
  _FilterQueryResult _buildFilterQuery({
    List<String>? categories,
    String? priceRange,
    double? minRating,
    bool? openNow,
  }) {
    String where = '1=1';
    List<dynamic> whereArgs = [];

    if (categories != null && categories.isNotEmpty) {
      final placeholders = categories.map((_) => '?').join(',');
      where += ' AND category IN ($placeholders)';
      whereArgs.addAll(categories);
    }

    if (priceRange != null) {
      where += ' AND price_range = ?';
      whereArgs.add(priceRange);
    }

    if (minRating != null) {
      where += ' AND rating >= ?';
      whereArgs.add(minRating);
    }

    if (openNow != null && openNow) {
      where += ' AND is_open = 1';
    }

    return _FilterQueryResult(where: where, whereArgs: whereArgs);
  }

  /// Converte lista de Maps para lista de PlaceModel
  List<BusinessModel> _mapListToModels(List<Map<String, dynamic>> maps) {
    return maps.map((map) => BusinessModel.fromMap(map)).toList();
  }
}

/// Classe auxiliar para retornar resultado da construção de query de filtros
class _FilterQueryResult {
  final String where;
  final List<dynamic> whereArgs;

  _FilterQueryResult({required this.where, required this.whereArgs});
}
