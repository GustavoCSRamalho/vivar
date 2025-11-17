// domain/usecases/settings/get_settings_usecase.dart

import '../../entities/app_settings_entity.dart';
import '../../repositories/settings_repository_protocol.dart';

class GetSettingsUseCase {
  final SettingsRepositoryProtocol _repository;

  GetSettingsUseCase(this._repository);

  Future<AppSettingsEntity> execute() async {
    try {
      return await _repository.getSettings();
    } catch (e) {
      print('❌ Erro ao buscar configurações: $e');
      return AppSettingsEntity();
    }
  }
}
