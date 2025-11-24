// presentation/providers/place_details_provider.dart

import 'package:flutter/foundation.dart';
import 'package:vivar/domain/entity/business/business_entity.dart';

import 'package:vivar/domain/entity/place/place_details_entity.dart';
import 'package:vivar/domain/entity/review/review_entity.dart';
import 'package:vivar/domain/usecases/place_details/add_review_usecase.dart';
import 'package:vivar/domain/usecases/place_details/check_user_reviewed_usecase.dart';
import 'package:vivar/domain/usecases/place_details/get_place_details_usecase.dart';
import 'package:vivar/domain/usecases/place_details/get_place_reviews_usecase.dart';

import '../../../../domain/usecases/place_details/get_place_by_Id_usecase.dart';

class PlaceDetailsProvider with ChangeNotifier {
  final GetPlaceDetailsUseCase _getPlaceDetailsUseCase;
  final GetPlaceReviewsUseCase _getPlaceReviewsUseCase;
  final AddReviewUseCase _addReviewUseCase;
  final CheckUserReviewedUseCase _checkUserReviewedUseCase;
  final GetPlaceByIdUseCase _getPlaceByIdUseCase;

  PlaceDetailsProvider({
    required GetPlaceDetailsUseCase getPlaceDetailsUseCase,
    required GetPlaceReviewsUseCase getPlaceReviewsUseCase,
    required AddReviewUseCase addReviewUseCase,
    required CheckUserReviewedUseCase checkUserReviewedUseCase,
    required GetPlaceByIdUseCase getPlaceByIdUseCase,
  }) : _getPlaceDetailsUseCase = getPlaceDetailsUseCase,
       _getPlaceReviewsUseCase = getPlaceReviewsUseCase,
       _addReviewUseCase = addReviewUseCase,
       _checkUserReviewedUseCase = checkUserReviewedUseCase,
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
  String? get error => _error;

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
