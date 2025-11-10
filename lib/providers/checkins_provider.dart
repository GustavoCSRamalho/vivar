// providers/checkins_provider.dart
import 'package:flutter/foundation.dart';
import '../models/checkin_model.dart';
import '../core/repositories/checkin_repository.dart';
import '../core/repositories/user_repository.dart';
import '../core/repositories/place_repository.dart';

class CheckinsProvider with ChangeNotifier {
  final CheckinRepository _checkinRepo = CheckinRepository();
  final UserRepository _userRepo = UserRepository();
  final PlaceRepository _placeRepo = PlaceRepository();

  List<CheckinModel> _checkins = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<CheckinModel> get checkins => _checkins;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Carregar check-ins do usuário
  Future<void> loadUserCheckins(String userId) async {
    try {
      _isLoading = true;
      notifyListeners();

      _checkins = await _checkinRepo.getUserCheckins(userId);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fazer check-in
  Future<CheckinModel?> doCheckin({
    required String userId,
    required String placeId,
    int? rating,
    String? comment,
  }) async {
    try {
      // Verificar se já fez check-in hoje
      final hasCheckedIn = await _checkinRepo.hasCheckedInToday(
        userId,
        placeId,
      );
      if (hasCheckedIn) {
        _error = 'Você já fez check-in neste lugar hoje';
        notifyListeners();
        return null;
      }

      // Criar check-in
      final checkin = CheckinModel(
        id: '${userId}_${placeId}_${DateTime.now().millisecondsSinceEpoch}',
        userId: userId,
        placeId: placeId,
        pointsEarned: 50, // Pontos base
        rating: rating,
        comment: comment,
        createdAt: DateTime.now(),
      );

      // Salvar check-in
      await _checkinRepo.insert(checkin);

      // Atualizar pontos do usuário
      await _userRepo.updatePoints(userId, checkin.pointsEarned);

      // Atualizar lugares visitados
      final uniquePlaces = await _checkinRepo.getUniquePlacesVisited(userId);
      await _userRepo.update(
        (await _userRepo.getById(userId))!.copyWith(
          placesVisited: uniquePlaces,
          points:
              (await _userRepo.getById(userId))!.points + checkin.pointsEarned,
        ),
      );

      // Recarregar check-ins
      await loadUserCheckins(userId);

      return checkin;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  // Obter check-ins recentes
  Future<List<CheckinModel>> getRecentCheckins(
    String userId, {
    int limit = 10,
  }) async {
    return await _checkinRepo.getRecentCheckins(userId, limit: limit);
  }

  // Obter total de pontos ganhos
  Future<int> getTotalPointsEarned(String userId) async {
    return await _checkinRepo.getTotalPointsEarned(userId);
  }

  // Obter contagem de check-ins
  Future<int> getCheckinCount(String userId) async {
    return await _checkinRepo.getCheckinCount(userId);
  }

  // Obter lugares únicos visitados
  Future<int> getUniquePlacesVisited(String userId) async {
    return await _checkinRepo.getUniquePlacesVisited(userId);
  }

  // Obter streak atual
  Future<int> getCurrentStreak(String userId) async {
    return await _checkinRepo.getCurrentStreak(userId);
  }
}
