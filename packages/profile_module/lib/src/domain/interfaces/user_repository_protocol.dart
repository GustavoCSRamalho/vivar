// domain/repositories/user_repository_protocol.dart
import 'package:profile_module/src/domain/entity/user_entity.dart';

abstract class UserRepositoryProtocol {
  Future<UserEntity?> getCurrentUser();
}
