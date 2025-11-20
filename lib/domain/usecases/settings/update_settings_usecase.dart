// domain/usecases/settings/update_settings_usecase.dart

import '../../entity/settings/app_settings_entity.dart';
import '../../interface/settings/settings_repository_protocol.dart';

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
