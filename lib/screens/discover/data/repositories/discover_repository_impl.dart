// data/repositories/discover_repository_impl.dart

import 'package:sqflite/sqflite.dart';
import 'package:vivar/core/database/database_helper.dart';
import 'package:vivar/screens/discover/domain/entities/discover_collection_entity.dart';
import 'package:vivar/screens/discover/domain/repositories/discover_repository_protocol.dart';
import 'package:vivar/screens/home/data/models/place_model.dart';
import 'package:vivar/screens/home/domain/entities/place_entity.dart';

class DiscoverRepositoryImpl implements DiscoverRepositoryProtocol {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final String _placeTableName = 'places';

  Future<Database> get _database async => await _dbHelper.database;

  @override
  Future<List<DiscoverCollectionEntity>> getCollections() async {
    final collections = <DiscoverCollectionEntity>[
      DiscoverCollectionEntity(
        id: 'trending',
        title: 'Em Alta',
        category: 'Tendências',
        description: 'Os lugares mais populares da semana',
        imageUrl: 'assets/images/trending.jpg',
        placesCount: 12,
      ),
      DiscoverCollectionEntity(
        id: 'near_you',
        title: 'Perto de Você',
        category: 'Proximidade',
        description: 'Descubra lugares próximos à sua localização',
        imageUrl: 'assets/images/near.jpg',
        placesCount: 8,
      ),
      DiscoverCollectionEntity(
        id: 'top_rated',
        title: 'Mais Bem Avaliados',
        category: 'Qualidade',
        description: 'Os lugares com as melhores avaliações',
        imageUrl: 'assets/images/top_rated.jpg',
        placesCount: 15,
      ),
      DiscoverCollectionEntity(
        id: 'new',
        title: 'Novos Lugares',
        category: 'Novidades',
        description: 'Lugares recém adicionados ao app',
        imageUrl: 'assets/images/new.jpg',
        placesCount: 6,
      ),
    ];

    return collections;
  }

  @override
  Future<List<PlaceEntity>> getCollectionPlaces(String collectionId) async {
    switch (collectionId) {
      case 'trending':
        return await getTrendingPlaces();
      case 'near_you':
        return await getNearYouPlaces();
      case 'top_rated':
        return await getTopRatedPlaces();
      case 'new':
        return await _getNewPlaces();
      default:
        return [];
    }
  }

  @override
  Future<List<PlaceEntity>> getTrendingPlaces() async {
    final db = await _database;
    final List<Map<String, dynamic>> maps = await db.query(
      _placeTableName,
      orderBy: 'reviews_count DESC',
      limit: 12,
    );
    return maps.map((map) => _modelToEntity(PlaceModel.fromMap(map))).toList();
  }

  @override
  Future<List<PlaceEntity>> getNearYouPlaces() async {
    final db = await _database;
    final List<Map<String, dynamic>> maps = await db.query(
      _placeTableName,
      orderBy: 'distance ASC',
      limit: 8,
    );
    return maps.map((map) => _modelToEntity(PlaceModel.fromMap(map))).toList();
  }

  @override
  Future<List<PlaceEntity>> getTopRatedPlaces() async {
    final db = await _database;
    final List<Map<String, dynamic>> maps = await db.query(
      _placeTableName,
      where: 'rating >= ?',
      whereArgs: [4.5],
      orderBy: 'rating DESC, reviews_count DESC',
      limit: 15,
    );
    return maps.map((map) => _modelToEntity(PlaceModel.fromMap(map))).toList();
  }

  Future<List<PlaceEntity>> _getNewPlaces() async {
    final db = await _database;
    final List<Map<String, dynamic>> maps = await db.query(
      _placeTableName,
      orderBy: 'created_at DESC',
      limit: 6,
    );
    return maps.map((map) => _modelToEntity(PlaceModel.fromMap(map))).toList();
  }

  PlaceEntity _modelToEntity(PlaceModel model) {
    return PlaceEntity(
      id: model.id,
      name: model.name,
      category: model.category,
      description: model.description,
      address: model.address,
      city: model.city,
      state: model.state,
      latitude: model.latitude,
      longitude: model.longitude,
      phone: model.phone,
      whatsapp: model.whatsapp,
      email: model.email,
      website: model.website,
      rating: model.rating,
      reviewsCount: model.reviewsCount,
      priceRange: model.priceRange,
      isOpen: model.isOpen,
      openingHours: model.openingHours,
      amenities: model.amenities,
      images: model.images,
      discountText: model.discountText,
      discountPercentage: model.discountPercentage,
      isPremiumOnly: model.isPremiumOnly,
      distance: model.distance,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }
}
