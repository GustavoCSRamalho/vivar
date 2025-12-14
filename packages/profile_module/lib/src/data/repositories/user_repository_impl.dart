// data/repositories/user_repository_impl.dart

import 'package:profile_module/src/data/models/user_model.dart';
import 'package:profile_module/src/domain/entity/user_entity.dart';
import 'package:profile_module/src/domain/interfaces/user_repository_protocol.dart';
import '../datasource/user/home_user_sync_datasource.dart';

/// Implementação do repositório de usuário
/// Delega operações de dados para o datasource de sincronização
/// Responsável por converter entre Model (data layer) e Entity (domain layer)
class UserRepositoryImpl implements UserRepositoryProtocol {
  final UserSyncDatasource _syncDatasource;

  UserRepositoryImpl({required UserSyncDatasource syncDatasource})
    : _syncDatasource = syncDatasource;

  @override
  Future<UserEntity?> getCurrentUser() async {
    final model = await _syncDatasource.getCurrentUser();
    return model != null ? _modelToEntity(model) : null;
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
      businessesVisited: model.businessesVisited,
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
      businessesVisited: entity.businessesVisited,
      badgesCount: entity.badgesCount,
      streakDays: entity.streakDays,
      favoriteCount: entity.favoriteCount,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
