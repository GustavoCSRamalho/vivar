// // data/repositories/challenges_repository_impl.dart

// import 'package:vivar/domain/entity/challenge/challenge_entity.dart';
// import 'package:vivar/domain/interface/challenges/challenges_repository_protocol.dart';
// import 'package:vivar/screens/challenges/data/datasource/challenge_datasource.dart';

// /// Implementação do repositório de desafios
// /// Delega operações de dados para o datasource
// /// Implementa múltiplos protocolos da camada de domínio
// class ChallengesRepositoryImpl
//     implements
//         GetChallengesProtocol,
//         GetActiveChallengesProtocol,
//         GetCompletedChallengesProtocol,
//         UpdateChallengeProgressProtocol,
//         CompleteChallengeProtocol {
//   final ChallengeDatasourceProtocol _datasource;

//   ChallengesRepositoryImpl({required ChallengeDatasourceProtocol datasource})
//     : _datasource = datasource;

//   @override
//   Future<List<ChallengeEntity>> getChallenges(String userId) {
//     return _datasource.getChallenges(userId);
//   }

//   @override
//   Future<List<ChallengeEntity>> getActiveChallenges(String userId) {
//     return _datasource.getActiveChallenges(userId);
//   }

//   @override
//   Future<List<ChallengeEntity>> getCompletedChallenges(String userId) {
//     return _datasource.getCompletedChallenges(userId);
//   }

//   @override
//   Future<void> updateChallengeProgress(
//     String userId,
//     String challengeId,
//     int newCount,
//   ) {
//     return _datasource.updateChallengeProgress(userId, challengeId, newCount);
//   }

//   @override
//   Future<void> completeChallenge(String userId, String challengeId) {
//     return _datasource.completeChallenge(userId, challengeId);
//   }

//   /// Método auxiliar para criar desafios de exemplo
//   Future<void> createSampleChallenges() {
//     return _datasource.createSampleChallenges();
//   }
// }
