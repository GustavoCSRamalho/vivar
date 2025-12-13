// domain/usecases/profile/update_user_profile_usecase.dart

import 'package:profile_module/src/domain/entity/user_profile_update_entity.dart';
import 'package:profile_module/src/domain/interfaces/user_profile_repository_protocol.dart';

class UpdateUserProfileUseCase {
  final UserProfileRepositoryProtocol _repository;

  UpdateUserProfileUseCase(this._repository);

  Future<void> execute(UserProfileUpdateEntity profile) async {
    if (profile.name.trim().isEmpty) {
      throw Exception('Nome é obrigatório');
    }

    if (profile.name.trim().length < 3) {
      throw Exception('Nome deve ter no mínimo 3 caracteres');
    }

    if (profile.username != null && profile.username!.isNotEmpty) {
      if (!_isValidUsername(profile.username!)) {
        throw Exception('Username inválido. Use apenas letras, números e _');
      }
    }

    if (profile.phone != null && profile.phone!.isNotEmpty) {
      if (profile.phone!.length < 10) {
        throw Exception('Telefone inválido');
      }
    }

    try {
      await _repository.updateUserProfile(profile);
    } catch (e) {
      print('❌ Erro ao atualizar perfil: $e');
      rethrow;
    }
  }

  bool _isValidUsername(String username) {
    final regex = RegExp(r'^[a-zA-Z0-9_]+$');
    return regex.hasMatch(username);
  }
}
