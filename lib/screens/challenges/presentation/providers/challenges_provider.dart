// // presentation/providers/challenges_provider.dart

// import 'package:flutter/foundation.dart';

// import '../../../../domain/entity/challenge/challenge_entity.dart';
// import '../../../../domain/usecases/challenges/complete_challenge_usecase.dart';
// import '../../../../domain/usecases/challenges/get_active_challenges_usecase.dart';
// import '../../../../domain/usecases/challenges/get_challenges_usecase.dart';
// import '../../../../domain/usecases/challenges/get_completed_challenges_usecase.dart';
// import '../../../../domain/usecases/challenges/update_challenge_progress_usecase.dart';

// class ChallengesProvider with ChangeNotifier {
//   final GetChallengesUseCase _getChallengesUseCase;
//   final GetActiveChallengesUseCase _getActiveChallengesUseCase;
//   final GetCompletedChallengesUseCase _getCompletedChallengesUseCase;
//   final UpdateChallengeProgressUseCase _updateChallengeProgressUseCase;
//   final CompleteChallengeUseCase _completeChallengeUseCase;

//   ChallengesProvider({
//     required GetChallengesUseCase getChallengesUseCase,
//     required GetActiveChallengesUseCase getActiveChallengesUseCase,
//     required GetCompletedChallengesUseCase getCompletedChallengesUseCase,
//     required UpdateChallengeProgressUseCase updateChallengeProgressUseCase,
//     required CompleteChallengeUseCase completeChallengeUseCase,
//   }) : _getChallengesUseCase = getChallengesUseCase,
//        _getActiveChallengesUseCase = getActiveChallengesUseCase,
//        _getCompletedChallengesUseCase = getCompletedChallengesUseCase,
//        _updateChallengeProgressUseCase = updateChallengeProgressUseCase,
//        _completeChallengeUseCase = completeChallengeUseCase;

//   List<ChallengeEntity> _challenges = [];
//   List<ChallengeEntity> _activeChallenges = [];
//   List<ChallengeEntity> _completedChallenges = [];
//   bool _isLoading = false;
//   String? _error;

//   List<ChallengeEntity> get challenges => _challenges;
//   List<ChallengeEntity> get activeChallenges => _activeChallenges;
//   List<ChallengeEntity> get completedChallenges => _completedChallenges;
//   bool get isLoading => _isLoading;
//   String? get error => _error;

//   Future<void> loadChallenges(String userId) async {
//     _setLoading(true);
//     _error = null;

//     try {
//       _challenges = await _getChallengesUseCase.execute(userId);
//       _activeChallenges = await _getActiveChallengesUseCase.execute(userId);
//       _completedChallenges = await _getCompletedChallengesUseCase.execute(
//         userId,
//       );

//       debugPrint('✅ Desafios carregados: ${_challenges.length}');
//       debugPrint('   - Ativos: ${_activeChallenges.length}');
//       debugPrint('   - Concluídos: ${_completedChallenges.length}');
//     } catch (e) {
//       _error = 'Erro ao carregar desafios';
//       debugPrint('❌ Erro ao carregar desafios: $e');
//     } finally {
//       _setLoading(false);
//     }
//   }

//   Future<bool> updateProgress(
//     String userId,
//     String challengeId,
//     int newCount,
//   ) async {
//     try {
//       await _updateChallengeProgressUseCase.execute(
//         userId,
//         challengeId,
//         newCount,
//       );

//       // Recarregar desafios
//       await loadChallenges(userId);

//       debugPrint('✅ Progresso do desafio atualizado');
//       return true;
//     } catch (e) {
//       _error = 'Erro ao atualizar progresso';
//       debugPrint('❌ Erro ao atualizar progresso: $e');
//       notifyListeners();
//       return false;
//     }
//   }

//   Future<bool> completeChallenge(String userId, String challengeId) async {
//     _setLoading(true);
//     _error = null;

//     try {
//       await _completeChallengeUseCase.execute(userId, challengeId);

//       // Recarregar desafios
//       await loadChallenges(userId);

//       debugPrint('✅ Desafio completado');
//       _setLoading(false);
//       return true;
//     } catch (e) {
//       _error = 'Erro ao completar desafio';
//       debugPrint('❌ Erro ao completar desafio: $e');
//       _setLoading(false);
//       return false;
//     }
//   }

//   void clearError() {
//     _error = null;
//     notifyListeners();
//   }

//   void _setLoading(bool value) {
//     _isLoading = value;
//     notifyListeners();
//   }
// }
