// domain/usecases/settings/update_settings_usecase.dart

import 'package:profile_module/src/domain/entity/app_settings_entity.dart';
import 'package:profile_module/src/domain/interfaces/settings_repository_protocol.dart';

class UpdateSettingsUseCase {
  final SettingsRepositoryProtocol _repository;

  UpdateSettingsUseCase(this._repository);

  Future<void> execute(AppSettingsEntity settings) async {
    try {
      await _repository.updateSettings(settings);
    } catch (e) {
      print('❌ Erro ao atualizar configurações: $e');
      rethrow;
    }
  }
}
