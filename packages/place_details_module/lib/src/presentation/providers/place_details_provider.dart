// presentation/providers/place_details_provider.dart

import 'package:flutter/foundation.dart';
import 'package:place_details_module/src/domain/entity/business_entity.dart';
import 'package:place_details_module/src/domain/entity/review_entity.dart';
import 'package:place_details_module/src/domain/entity/user_entity.dart';
import 'package:place_details_module/src/domain/usecase/add_review_usecase.dart';
import 'package:place_details_module/src/domain/usecase/check_user_reviewed_usecase.dart';
import 'package:place_details_module/src/domain/usecase/get_current_user_usecase.dart';
import 'package:place_details_module/src/domain/usecase/get_place_by_Id_usecase.dart';
import 'package:place_details_module/src/domain/usecase/get_place_details_usecase.dart';
import 'package:place_details_module/src/domain/usecase/get_place_reviews_usecase.dart';
import 'package:place_details_module/src/domain/usecase/load_user_favorites_usecase.dart';
import 'package:place_details_module/src/domain/usecase/toggle_favorite_place_usecase.dart';

class PlaceDetailsProvider with ChangeNotifier {
  final GetPlaceDetailsUseCase _getPlaceDetailsUseCase;
  final GetPlaceReviewsUseCase _getPlaceReviewsUseCase;
  final AddReviewUseCase _addReviewUseCase;
  final CheckUserReviewedUseCase _checkUserReviewedUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final ToggleFavoriteBusinessesUseCase _toggleFavoriteBusinessesUseCase;
  final GetPlaceByIdUseCase _getPlaceByIdUseCase;
  final LoadUserFavoritesUseCase _loadUserFavoritesUseCase;

  PlaceDetailsProvider({
    required GetPlaceDetailsUseCase getPlaceDetailsUseCase,
    required GetPlaceReviewsUseCase getPlaceReviewsUseCase,
    required AddReviewUseCase addReviewUseCase,
    required CheckUserReviewedUseCase checkUserReviewedUseCase,
    required GetPlaceByIdUseCase getPlaceByIdUseCase,
    required ToggleFavoriteBusinessesUseCase toggleFavoriteBusinessesUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required LoadUserFavoritesUseCase loadUserFavoritesUseCase,
  }) : _getPlaceDetailsUseCase = getPlaceDetailsUseCase,
       _getPlaceReviewsUseCase = getPlaceReviewsUseCase,
       _addReviewUseCase = addReviewUseCase,
       _checkUserReviewedUseCase = checkUserReviewedUseCase,
       _loadUserFavoritesUseCase = loadUserFavoritesUseCase,
       _toggleFavoriteBusinessesUseCase = toggleFavoriteBusinessesUseCase,
       _getCurrentUserUseCase = getCurrentUserUseCase,
       _getPlaceByIdUseCase = getPlaceByIdUseCase;

  BusinessEntity? _place;
  List<ReviewEntity> _reviews = [];
  bool _hasUserReviewed = false;
  bool _isLoading = false;
  String? _error;

  BusinessEntity? get place => _place;
  List<ReviewEntity> get reviews => _reviews;
  bool get hasUserReviewed => _hasUserReviewed;
  bool get isLoading => _isLoading;
  List<String> _favoritePlaceIds = [];
  String? get error => _error;
  bool isFavorite(String placeId) {
    return _favoritePlaceIds.contains(placeId);
  }

  UserEntity? get currentUser => _currentUser;
  UserEntity? _currentUser;

  Future<void> toggleFavorite(String placeId) async {
    if (_currentUser == null) return;

    try {
      final isFavorite = await _toggleFavoriteBusinessesUseCase.execute(
        userId: _currentUser!.id,
        placeId: placeId,
      );

      if (isFavorite) {
        _favoritePlaceIds.add(placeId);
      } else {
        _favoritePlaceIds.remove(placeId);
      }

      notifyListeners();
      debugPrint('✅ Favorito alternado: $placeId');
    } catch (e) {
      debugPrint('❌ Erro ao alternar favorito: $e');
    }
  }

  /// Carrega os favoritos do usuário
  Future<void> _loadFavorites() async {
    if (_currentUser == null) return;

    try {
      _favoritePlaceIds = await _loadUserFavoritesUseCase.execute(
        _currentUser!.id,
      );
      debugPrint('✅ ${_favoritePlaceIds.length} favoritos carregados');
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Erro ao carregar favoritos: $e');
    }
  }

  Future<void> _loadUser() async {
    try {
      _currentUser = await _getCurrentUserUseCase.execute();
      debugPrint('✅ Usuário carregado: ${_currentUser?.name}');
    } catch (e) {
      debugPrint('❌ Erro ao carregar usuário: $e');
    }
  }

  Future<void> loadPlaceDetails(String placeId, String userId) async {
    _setLoading(true);
    _error = null;

    try {
      _place = await _getPlaceDetailsUseCase.execute(placeId);
      _reviews = await _getPlaceReviewsUseCase.execute(placeId);
      _hasUserReviewed = await _checkUserReviewedUseCase.execute(
        userId,
        placeId,
      );

      debugPrint('✅ Detalhes do lugar carregados');
    } catch (e) {
      _error = 'Erro ao carregar detalhes: $e';
      debugPrint('❌ Erro ao carregar detalhes: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> getPlaceById(String placeId) async {
    _setLoading(true);
    _error = null;

    try {
      _place = await _getPlaceByIdUseCase.execute(placeId);

      debugPrint('✅ Detalhes do lugar carregados');
    } catch (e) {
      _error = 'Erro ao carregar detalhes: $e';
      debugPrint('❌ Erro ao carregar detalhes: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addReview(ReviewEntity review) async {
    try {
      await _addReviewUseCase.execute(review);
      _reviews.insert(0, review);
      _hasUserReviewed = true;
      notifyListeners();
      debugPrint('✅ Review adicionada');
    } catch (e) {
      debugPrint('❌ Erro ao adicionar review: $e');
      rethrow;
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
