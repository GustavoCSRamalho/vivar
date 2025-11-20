// domain/usecases/profile/update_profile_usecase.dart

import '../../entity/profile/profile_entity.dart';
import '../../interface/profile/profile_repository_protocol.dart';

class UpdateProfileUseCase {
  final ProfileRepositoryProtocol _profileRepository;

  UpdateProfileUseCase(this._profileRepository);

  Future<void> execute(ProfileEntity profile) async {
    try {
      await _profileRepository.updateProfile(profile);
    } catch (e) {
      print('❌ Erro ao atualizar perfil: $e');
      rethrow;
    }
  }
}
