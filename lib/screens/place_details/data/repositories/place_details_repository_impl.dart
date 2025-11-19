// data/repositories/place_details_repository_impl.dart

import 'package:sqflite/sqflite.dart';
import 'package:vivar/core/database/database_helper.dart';
import 'package:vivar/models/review_model.dart';
import 'package:vivar/screens/home/data/models/place_model.dart';
import 'package:vivar/screens/place_details/domain/entities/place_details_entity.dart';
import 'package:vivar/screens/place_details/domain/entities/review_entity.dart';
import 'package:vivar/screens/place_details/domain/repositories/place_details_repository_protocol.dart';

class PlaceDetailsRepositoryImpl implements PlaceDetailsRepositoryProtocol {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final String _placeTableName = 'places';
  final String _reviewTableName = 'reviews';
  final String _userTableName = 'users';

  Future<Database> get _database async => await _dbHelper.database;

  @override
  Future<PlaceDetailsEntity?> getPlaceDetails(String placeId) async {
    final db = await _database;
    final List<Map<String, dynamic>> maps = await db.query(
      _placeTableName,
      where: 'id = ?',
      whereArgs: [placeId],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return _placeModelToEntity(PlaceModel.fromMap(maps.first));
  }

  @override
  Future<List<ReviewEntity>> getPlaceReviews(String placeId) async {
    final db = await _database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT r.*, u.name as user_name, u.avatar_url as user_avatar_url
      FROM $_reviewTableName r
      LEFT JOIN $_userTableName u ON r.user_id = u.id
      WHERE r.place_id = ?
      ORDER BY r.created_at DESC
    ''',
      [placeId],
    );

    return maps.map((map) => _reviewMapToEntity(map)).toList();
  }

  @override
  Future<void> addReview(ReviewEntity review) async {
    final db = await _database;
    final reviewModel = ReviewModel(
      id: review.id,
      userId: review.userId,
      placeId: review.placeId,
      rating: review.rating,
      comment: review.comment,
      images: review.images,
      createdAt: review.createdAt,
      updatedAt: review.updatedAt,
    );

    await db.insert(
      _reviewTableName,
      reviewModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<bool> checkIfUserReviewed(String userId, String placeId) async {
    final db = await _database;
    final result = await db.query(
      _reviewTableName,
      where: 'user_id = ? AND place_id = ?',
      whereArgs: [userId, placeId],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  PlaceDetailsEntity _placeModelToEntity(PlaceModel model) {
    return PlaceDetailsEntity(
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
    );
  }

  ReviewEntity _reviewMapToEntity(Map<String, dynamic> map) {
    return ReviewEntity(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      placeId: map['place_id'] as String,
      userName: map['user_name'] as String? ?? 'Usuário',
      userAvatarUrl: map['user_avatar_url'] as String?,
      rating: map['rating'] as double,
      comment: map['comment'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
      images: map['images'] != null ? List<String>.from(map['images']) : null,
    );
  }

  @override
  Future<PlaceDetailsEntity?> getPlaceById(String id) async {
    final db = await _database;
    final List<Map<String, dynamic>> maps = await db.query(
      _placeTableName,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    final model = PlaceModel.fromMap(maps.first);
    return PlaceDetailsEntity(
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
    );
  }
}
