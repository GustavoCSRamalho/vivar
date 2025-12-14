// // domain/usecases/challenges/update_challenge_progress_usecase.dart

// import '../../interface/challenges/challenges_repository_protocol.dart';

// class UpdateChallengeProgressUseCase {
//   final UpdateChallengeProgressProtocol _repository;

//   UpdateChallengeProgressUseCase(this._repository);

//   Future<void> execute(String userId, String challengeId, int newCount) async {
//     if (userId.trim().isEmpty) {
//       throw Exception('ID do usuário é obrigatório');
//     }

//     if (challengeId.trim().isEmpty) {
//       throw Exception('ID do desafio é obrigatório');
//     }

//     if (newCount < 0) {
//       throw Exception('Contagem não pode ser negativa');
//     }

//     try {
//       await _repository.updateChallengeProgress(userId, challengeId, newCount);
//     } catch (e) {
//       print('❌ Erro ao atualizar progresso: $e');
//       rethrow;
//     }
//   }
// }
