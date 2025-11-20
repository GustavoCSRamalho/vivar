// domain/usecases/challenges/get_challenges_usecase.dart

import '../../entity/challenge/challenge_entity.dart';
import '../../interface/challenges/challenges_repository_protocol.dart';

class GetChallengesUseCase {
  final GetChallengesProtocol _repository;

  GetChallengesUseCase(this._repository);

  Future<List<ChallengeEntity>> execute(String userId) async {
    if (userId.trim().isEmpty) {
      throw Exception('ID do usuário é obrigatório');
    }

    try {
      return await _repository.getChallenges(userId);
    } catch (e) {
      print('❌ Erro ao buscar desafios: $e');
      return [];
    }
  }
}
