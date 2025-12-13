// presentation/providers/swipe_provider.dart

import 'package:flutter/foundation.dart';
import 'package:swipe_module/src/domain/entity/swipe_place_entity.dart';
import 'package:swipe_module/src/domain/usecases/dislike_place_usecase.dart';
import 'package:swipe_module/src/domain/usecases/get_swipe_places_usecase.dart';
import 'package:swipe_module/src/domain/usecases/like_place_usecase.dart';
import 'package:swipe_module/src/domain/usecases/super_like_place_usecase.dart';

class SwipeProvider with ChangeNotifier {
  final GetSwipeBusinessesUseCase _getSwipeBusinessesUseCase;
  final LikeBusinessesUseCase _likeBusinessesUseCase;
  final DislikeBusinessesUseCase _dislikeBusinessesUseCase;
  final SuperLikeBusinessesUseCase _superLikeBusinessesUseCase;

  SwipeProvider({
    required GetSwipeBusinessesUseCase getSwipeBusinessesUseCase,
    required LikeBusinessesUseCase likeBusinessesUseCase,
    required DislikeBusinessesUseCase dislikeBusinessesUseCase,
    required SuperLikeBusinessesUseCase superLikeBusinessesUseCase,
  }) : _getSwipeBusinessesUseCase = getSwipeBusinessesUseCase,
       _likeBusinessesUseCase = likeBusinessesUseCase,
       _dislikeBusinessesUseCase = dislikeBusinessesUseCase,
       _superLikeBusinessesUseCase = superLikeBusinessesUseCase;

  List<SwipeBusinessesEntity> _Businesses = [];
  int _currentIndex = 0;
  bool _isLoading = false;
  String? _error;

  List<SwipeBusinessesEntity> get Businesses => _Businesses;
  int get currentIndex => _currentIndex;
  int get remainingCount => _Businesses.length - _currentIndex;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasBusinesses => _currentIndex < _Businesses.length;
  SwipeBusinessesEntity? get currentBusinesses =>
      hasBusinesses ? _Businesses[_currentIndex] : null;

  Future<void> initialize() async {
    _setLoading(true);
    _error = null;

    try {
      _Businesses = await _getSwipeBusinessesUseCase.execute();
      _currentIndex = 0;
      debugPrint('✅ ${_Businesses.length} lugares carregados para swipe');
    } catch (e) {
      _error = 'Erro ao carregar lugares: $e';
      debugPrint('❌ Erro ao carregar lugares: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> like(String userId) async {
    if (!hasBusinesses) return;

    try {
      await _likeBusinessesUseCase.execute(
        userId,
        _Businesses[_currentIndex].id,
      );
      _nextBusinesses();
      debugPrint('✅ Like dado no lugar');
    } catch (e) {
      debugPrint('❌ Erro ao dar like: $e');
    }
  }

  Future<void> dislike(String userId) async {
    if (!hasBusinesses) return;

    try {
      await _dislikeBusinessesUseCase.execute(
        userId,
        _Businesses[_currentIndex].id,
      );
      _nextBusinesses();
      debugPrint('✅ Dislike dado no lugar');
    } catch (e) {
      debugPrint('❌ Erro ao dar dislike: $e');
    }
  }

  Future<void> superLike(String userId) async {
    if (!hasBusinesses) return;

    try {
      await _superLikeBusinessesUseCase.execute(
        userId,
        _Businesses[_currentIndex].id,
      );
      _nextBusinesses();
      debugPrint('✅ Super like dado no lugar');
    } catch (e) {
      debugPrint('❌ Erro ao dar super like: $e');
    }
  }

  void _nextBusinesses() {
    if (_currentIndex < _Businesses.length - 1) {
      _currentIndex++;
      notifyListeners();
    } else {
      // Acabaram os lugares
      debugPrint('⚠️ Não há mais lugares para swipe');
    }
  }

  void reset() {
    _currentIndex = 0;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
