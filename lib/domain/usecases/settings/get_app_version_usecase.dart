// domain/usecases/settings/get_app_version_usecase.dart

import '../../interface/settings/settings_repository_protocol.dart';

class GetAppVersionUseCase {
  final SettingsRepositoryProtocol _repository;

  GetAppVersionUseCase(this._repository);

  Future<String> execute() async {
    try {
      return await _repository.getAppVersion();
    } catch (e) {
      print('❌ Erro ao buscar versão: $e');
      return '1.0.0';
    }
  }
}
