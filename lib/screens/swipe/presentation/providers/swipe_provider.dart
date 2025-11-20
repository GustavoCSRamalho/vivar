// presentation/providers/swipe_provider.dart

import 'package:flutter/foundation.dart';
import 'package:vivar/domain/entity/swipe/swipe_place_entity.dart';
import 'package:vivar/domain/usecases/swipe/dislike_place_usecase.dart';
import 'package:vivar/domain/usecases/swipe/get_swipe_places_usecase.dart';
import 'package:vivar/domain/usecases/swipe/like_place_usecase.dart';
import 'package:vivar/domain/usecases/swipe/super_like_place_usecase.dart';

class SwipeProvider with ChangeNotifier {
  final GetSwipePlacesUseCase _getSwipePlacesUseCase;
  final LikePlaceUseCase _likePlaceUseCase;
  final DislikePlaceUseCase _dislikePlaceUseCase;
  final SuperLikePlaceUseCase _superLikePlaceUseCase;

  SwipeProvider({
    required GetSwipePlacesUseCase getSwipePlacesUseCase,
    required LikePlaceUseCase likePlaceUseCase,
    required DislikePlaceUseCase dislikePlaceUseCase,
    required SuperLikePlaceUseCase superLikePlaceUseCase,
  }) : _getSwipePlacesUseCase = getSwipePlacesUseCase,
       _likePlaceUseCase = likePlaceUseCase,
       _dislikePlaceUseCase = dislikePlaceUseCase,
       _superLikePlaceUseCase = superLikePlaceUseCase;

  List<SwipePlaceEntity> _places = [];
  int _currentIndex = 0;
  bool _isLoading = false;
  String? _error;

  List<SwipePlaceEntity> get places => _places;
  int get currentIndex => _currentIndex;
  int get remainingCount => _places.length - _currentIndex;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasPlaces => _currentIndex < _places.length;
  SwipePlaceEntity? get currentPlace =>
      hasPlaces ? _places[_currentIndex] : null;

  Future<void> initialize() async {
    _setLoading(true);
    _error = null;

    try {
      _places = await _getSwipePlacesUseCase.execute();
      _currentIndex = 0;
      debugPrint('✅ ${_places.length} lugares carregados para swipe');
    } catch (e) {
      _error = 'Erro ao carregar lugares: $e';
      debugPrint('❌ Erro ao carregar lugares: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> like(String userId) async {
    if (!hasPlaces) return;

    try {
      await _likePlaceUseCase.execute(userId, _places[_currentIndex].id);
      _nextPlace();
      debugPrint('✅ Like dado no lugar');
    } catch (e) {
      debugPrint('❌ Erro ao dar like: $e');
    }
  }

  Future<void> dislike(String userId) async {
    if (!hasPlaces) return;

    try {
      await _dislikePlaceUseCase.execute(userId, _places[_currentIndex].id);
      _nextPlace();
      debugPrint('✅ Dislike dado no lugar');
    } catch (e) {
      debugPrint('❌ Erro ao dar dislike: $e');
    }
  }

  Future<void> superLike(String userId) async {
    if (!hasPlaces) return;

    try {
      await _superLikePlaceUseCase.execute(userId, _places[_currentIndex].id);
      _nextPlace();
      debugPrint('✅ Super like dado no lugar');
    } catch (e) {
      debugPrint('❌ Erro ao dar super like: $e');
    }
  }

  void _nextPlace() {
    if (_currentIndex < _places.length - 1) {
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
