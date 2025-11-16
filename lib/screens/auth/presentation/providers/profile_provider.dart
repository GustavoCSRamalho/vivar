// presentation/providers/profile_provider.dart

import 'package:flutter/foundation.dart';
import 'package:vivar/screens/auth/domain/entities/profile_entity.dart';
import 'package:vivar/screens/auth/domain/usecases/profile/get_profile_usecase.dart';
import 'package:vivar/screens/auth/domain/usecases/profile/get_recent_badges_usecase.dart';
import 'package:vivar/screens/auth/domain/usecases/profile/get_recent_checkins_count_usecase.dart';
import 'package:vivar/screens/auth/domain/usecases/profile/update_profile_usecase.dart';

class ProfileProvider with ChangeNotifier {
  final GetProfileUseCase _getProfileUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;
  final GetRecentCheckinsCountUseCase _getRecentCheckinsCountUseCase;
  final GetRecentBadgesUseCase _getRecentBadgesUseCase;

  ProfileProvider({
    required GetProfileUseCase getProfileUseCase,
    required UpdateProfileUseCase updateProfileUseCase,
    required GetRecentCheckinsCountUseCase getRecentCheckinsCountUseCase,
    required GetRecentBadgesUseCase getRecentBadgesUseCase,
  }) : _getProfileUseCase = getProfileUseCase,
       _updateProfileUseCase = updateProfileUseCase,
       _getRecentCheckinsCountUseCase = getRecentCheckinsCountUseCase,
       _getRecentBadgesUseCase = getRecentBadgesUseCase;

  ProfileEntity? _profile;
  int _recentCheckinsCount = 0;
  List<String> _recentBadges = [];
  bool _isLoading = false;
  String? _error;

  ProfileEntity? get profile => _profile;
  int get recentCheckinsCount => _recentCheckinsCount;
  List<String> get recentBadges => _recentBadges;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadProfile(String userId) async {
    _setLoading(true);
    _error = null;

    try {
      _profile = await _getProfileUseCase.execute(userId);

      if (_profile != null) {
        await _loadAdditionalData(userId);
      }

      debugPrint('✅ Perfil carregado');
    } catch (e) {
      _error = 'Erro ao carregar perfil: $e';
      debugPrint('❌ Erro ao carregar perfil: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _loadAdditionalData(String userId) async {
    try {
      _recentCheckinsCount = await _getRecentCheckinsCountUseCase.execute(
        userId,
      );
      _recentBadges = await _getRecentBadgesUseCase.execute(userId, limit: 5);
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Erro ao carregar dados adicionais: $e');
    }
  }

  Future<void> updateProfile(ProfileEntity profile) async {
    try {
      await _updateProfileUseCase.execute(profile);
      _profile = profile;
      notifyListeners();
      debugPrint('✅ Perfil atualizado');
    } catch (e) {
      debugPrint('❌ Erro ao atualizar perfil: $e');
      rethrow;
    }
  }

  Future<void> refresh(String userId) async {
    await loadProfile(userId);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
