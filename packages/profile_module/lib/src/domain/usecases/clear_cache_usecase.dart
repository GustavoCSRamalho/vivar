// domain/usecases/settings/clear_cache_usecase.dart

import 'package:profile_module/src/domain/interfaces/settings_repository_protocol.dart';

class ClearCacheUseCase {
  final SettingsRepositoryProtocol _repository;

  ClearCacheUseCase(this._repository);

  Future<void> execute() async {
    try {
      await _repository.clearCache();
    } catch (e) {
      print('❌ Erro ao limpar cache: $e');
      rethrow;
    }
  }
}
