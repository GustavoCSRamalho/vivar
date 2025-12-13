// domain/usecases/settings/get_settings_usecase.dart

import 'package:profile_module/src/domain/entity/app_settings_entity.dart';
import 'package:profile_module/src/domain/interfaces/settings_repository_protocol.dart';

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
