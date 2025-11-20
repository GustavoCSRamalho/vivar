// data/repositories/user_repository_impl.dart

import 'package:vivar/models/user_model.dart';
import 'package:vivar/domain/entity/user/user_entity.dart';
import 'package:vivar/domain/interface/user/user_repository_protocol.dart';
import 'package:vivar/screens/home/data/datasource/user_datasource.dart';

/// Implementação do repositório de usuário
/// Delega operações de dados para o datasource
/// Responsável por converter entre Model (data layer) e Entity (domain layer)
class UserRepositoryImpl implements UserRepositoryProtocol {
  final UserDatasourceProtocol _datasource;

  UserRepositoryImpl({required UserDatasourceProtocol datasource})
    : _datasource = datasource;

  @override
  Future<UserEntity?> getCurrentUser() async {
    final model = await _datasource.getCurrentUser();
    return model != null ? _modelToEntity(model) : null;
  }

  @override
  Future<UserEntity?> getUserById(String id) async {
    final model = await _datasource.getUserById(id);
    return model != null ? _modelToEntity(model) : null;
  }

  @override
  Future<void> updateUser(UserEntity user) async {
    final model = _entityToModel(user);
    await _datasource.updateUser(model);
  }

  @override
  Future<List<String>> getUserFavoritePlaceIds(String userId) {
    return _datasource.getUserFavoritePlaceIds(userId);
  }

  @override
  Future<void> addFavorite(String userId, String placeId) {
    return _datasource.addFavorite(userId, placeId);
  }

  @override
  Future<void> removeFavorite(String userId, String placeId) {
    return _datasource.removeFavorite(userId, placeId);
  }

  @override
  Future<bool> toggleFavorite(String userId, String placeId) {
    return _datasource.toggleFavorite(userId, placeId);
  }

  /// Converte UserModel (data layer) para UserEntity (domain layer)
  UserEntity _modelToEntity(UserModel model) {
    return UserEntity(
      id: model.id,
      email: model.email,
      name: model.name,
      username: model.username,
      avatarUrl: model.avatarUrl,
      bio: model.bio,
      phone: model.phone,
      location: model.location,
      planType: model.planType,
      points: model.points,
      placesVisited: model.placesVisited,
      badgesCount: model.badgesCount,
      streakDays: model.streakDays,
      favoriteCount: model.favoriteCount,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }

  /// Converte UserEntity (domain layer) para UserModel (data layer)
  UserModel _entityToModel(UserEntity entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      name: entity.name,
      username: entity.username,
      avatarUrl: entity.avatarUrl,
      bio: entity.bio,
      phone: entity.phone,
      location: entity.location,
      planType: entity.planType,
      points: entity.points,
      placesVisited: entity.placesVisited,
      badgesCount: entity.badgesCount,
      streakDays: entity.streakDays,
      favoriteCount: entity.favoriteCount,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
