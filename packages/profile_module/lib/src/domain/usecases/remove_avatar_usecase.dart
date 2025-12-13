// domain/usecases/profile/remove_avatar_usecase.dart

import 'package:profile_module/src/domain/interfaces/user_profile_repository_protocol.dart';

class RemoveAvatarUseCase {
  final UserProfileRepositoryProtocol _repository;

  RemoveAvatarUseCase(this._repository);

  Future<void> execute(String userId) async {
    try {
      await _repository.removeAvatar(userId);
    } catch (e) {
      print('❌ Erro ao remover avatar: $e');
      rethrow;
    }
  }
}
