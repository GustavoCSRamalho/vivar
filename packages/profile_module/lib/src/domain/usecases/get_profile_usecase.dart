// domain/usecases/profile/get_profile_usecase.dart

import 'package:profile_module/src/domain/entity/profile_entity.dart';
import 'package:profile_module/src/domain/interfaces/profile_repository_protocol.dart';

class GetProfileUseCase {
  final ProfileRepositoryProtocol _profileRepository;

  GetProfileUseCase(this._profileRepository);

  Future<ProfileEntity?> execute(String userId) async {
    try {
      return await _profileRepository.getProfile(userId);
    } catch (e) {
      print('❌ Erro ao buscar perfil: $e');
      return null;
    }
  }
}
