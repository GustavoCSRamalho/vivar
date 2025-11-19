// domain/usecases/profile/get_recent_checkins_count_usecase.dart

import '../../interface/profile/profile_repository_protocol.dart';

class GetRecentCheckinsCountUseCase {
  final ProfileRepositoryProtocol _profileRepository;

  GetRecentCheckinsCountUseCase(this._profileRepository);

  Future<int> execute(String userId) async {
    try {
      return await _profileRepository.getRecentCheckinsCount(userId);
    } catch (e) {
      print('❌ Erro ao buscar checkins recentes: $e');
      return 0;
    }
  }
}
