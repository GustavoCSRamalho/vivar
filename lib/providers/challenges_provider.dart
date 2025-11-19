// providers/challenges_provider.dart
import 'package:flutter/foundation.dart';
import '../models/challenge_model.dart';
import '../core/repositories/challenge_repository.dart';
import '../core/repositories/badge_repository.dart';
import '../core/repositories/user_repository.dart';
import '../models/badge_model.dart';

class ChallengesProvider with ChangeNotifier {
  final ChallengeRepository _challengeRepo = ChallengeRepository();
  final BadgeRepository _badgeRepo = BadgeRepository();
  final UserRepository _userRepo = UserRepository();

  List<ChallengeModel> _activeChallenges = [];
  List<ChallengeModel> _completedChallenges = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<ChallengeModel> get activeChallenges => _activeChallenges;
  List<ChallengeModel> get completedChallenges => _completedChallenges;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<List<ChallengeModel>> getActiveChallenges(String userId) async {
    return await _challengeRepo.getActiveChallenges(userId);
  }

  // Carregar desafios
  Future<void> loadChallenges(String userId) async {
    try {
      _isLoading = true;
      notifyListeners();

      _activeChallenges = await _challengeRepo.getActiveChallenges(userId);
      _completedChallenges = await _challengeRepo.getCompletedChallenges(
        userId,
      );

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Incrementar progresso
  Future<void> incrementChallengeProgress(
    String challengeId,
    String userId,
    int amount,
  ) async {
    try {
      await _challengeRepo.incrementProgress(challengeId, amount);

      // Verificar se completou
      final challenge = await _challengeRepo.getById(challengeId);
      if (challenge != null && challenge.isCompleted) {
        await _rewardUser(userId, challenge);
      }

      await loadChallenges(userId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Recompensar usuário
  Future<void> _rewardUser(String userId, ChallengeModel challenge) async {
    // Adicionar pontos
    if (challenge.rewardPoints > 0) {
      await _userRepo.updatePoints(userId, challenge.rewardPoints);
    }

    // Adicionar badge
    if (challenge.rewardBadge != null) {
      final badge = BadgeModel(
        id: '${userId}_${challenge.rewardBadge}_${DateTime.now().millisecondsSinceEpoch}',
        userId: userId,
        badgeType: challenge.rewardBadge!,
        name: challenge.title,
        description: challenge.description,
        icon: '🏆',
        earnedAt: DateTime.now(),
      );

      await _badgeRepo.insert(badge);
      await _userRepo.incrementBadgesCount(userId);
    }
  }

  // Criar desafio personalizado
  Future<void> createChallenge(ChallengeModel challenge) async {
    try {
      await _challengeRepo.insert(challenge);
      await loadChallenges(challenge.userId!);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
