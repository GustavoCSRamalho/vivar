// domain/usecases/profile/upload_avatar_usecase.dart

import '../../interface/user/user_profile_repository_protocol.dart';

class UploadAvatarUseCase {
  final UserProfileRepositoryProtocol _repository;

  UploadAvatarUseCase(this._repository);

  Future<String> execute(String userId, String imagePath) async {
    if (imagePath.trim().isEmpty) {
      throw Exception('Caminho da imagem é obrigatório');
    }

    try {
      return await _repository.uploadAvatar(userId, imagePath);
    } catch (e) {
      print('❌ Erro ao fazer upload do avatar: $e');
      rethrow;
    }
  }
}
