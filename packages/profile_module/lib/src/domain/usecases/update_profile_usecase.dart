// domain/usecases/profile/update_profile_usecase.dart

import 'package:profile_module/src/domain/entity/profile_entity.dart';
import 'package:profile_module/src/domain/interfaces/profile_repository_protocol.dart';

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
