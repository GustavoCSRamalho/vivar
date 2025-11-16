// domain/usecases/profile/get_recent_badges_usecase.dart

import '../../repositories/profile_repository_protocol.dart';

class GetRecentBadgesUseCase {
  final ProfileRepositoryProtocol _profileRepository;

  GetRecentBadgesUseCase(this._profileRepository);

  Future<List<String>> execute(String userId, {int limit = 5}) async {
    try {
      return await _profileRepository.getRecentBadges(userId, limit: limit);
    } catch (e) {
      print('❌ Erro ao buscar badges recentes: $e');
      return [];
    }
  }
}
