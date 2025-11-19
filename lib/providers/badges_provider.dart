// providers/badges_provider.dart
import 'package:flutter/foundation.dart';
import '../models/badge_model.dart';
import '../core/repositories/badge_repository.dart';

class BadgesProvider with ChangeNotifier {
  final BadgeRepository _badgeRepo = BadgeRepository();

  List<BadgeModel> _badges = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<BadgeModel> get badges => _badges;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Carregar badges do usuário
  Future<void> loadUserBadges(String userId) async {
    try {
      _isLoading = true;
      notifyListeners();

      _badges = await _badgeRepo.getUserBadges(userId);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Adicionar badge
  Future<void> addBadge(BadgeModel badge) async {
    try {
      await _badgeRepo.insert(badge);
      await loadUserBadges(badge.userId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Verificar se tem badge
  Future<bool> hasBadge(String userId, String badgeType) async {
    return await _badgeRepo.hasBadge(userId, badgeType);
  }

  // Obter badges recentes
  Future<List<BadgeModel>> getRecentBadges(
    String userId, {
    int limit = 5,
  }) async {
    return await _badgeRepo.getRecentBadges(userId, limit: limit);
  }
}
