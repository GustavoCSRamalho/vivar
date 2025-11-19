// presentation/providers/discover_provider.dart

import 'package:flutter/foundation.dart';
import 'package:vivar/domain/entity/discover_collection_entity.dart';
import 'package:vivar/domain/usecases/discover/get_collection_places_usecase.dart';
import 'package:vivar/domain/usecases/discover/get_collections_usecase.dart';
import 'package:vivar/domain/usecases/discover/get_near_you_places_usecase.dart';
import 'package:vivar/domain/usecases/discover/get_trending_places_usecase.dart';
import 'package:vivar/domain/entity/place_entity.dart';
import 'package:vivar/domain/usecases/place/get_top_rated_places_usecase.dart';

class DiscoverProvider with ChangeNotifier {
  final GetCollectionsUseCase _getCollectionsUseCase;
  final GetCollectionPlacesUseCase _getCollectionPlacesUseCase;
  final GetTrendingPlacesUseCase _getTrendingPlacesUseCase;
  final GetNearYouPlacesUseCase _getNearYouPlacesUseCase;
  final GetTopRatedPlacesUseCase _getTopRatedPlacesUseCase;

  DiscoverProvider({
    required GetCollectionsUseCase getCollectionsUseCase,
    required GetCollectionPlacesUseCase getCollectionPlacesUseCase,
    required GetTrendingPlacesUseCase getTrendingPlacesUseCase,
    required GetNearYouPlacesUseCase getNearYouPlacesUseCase,
    required GetTopRatedPlacesUseCase getTopRatedPlacesUseCase,
  }) : _getCollectionsUseCase = getCollectionsUseCase,
       _getCollectionPlacesUseCase = getCollectionPlacesUseCase,
       _getTrendingPlacesUseCase = getTrendingPlacesUseCase,
       _getNearYouPlacesUseCase = getNearYouPlacesUseCase,
       _getTopRatedPlacesUseCase = getTopRatedPlacesUseCase;

  List<DiscoverCollectionEntity> _collections = [];
  List<PlaceEntity> _trendingPlaces = [];
  List<PlaceEntity> _nearYouPlaces = [];
  List<PlaceEntity> _topRatedPlaces = [];
  bool _isLoading = false;
  String? _error;

  List<DiscoverCollectionEntity> get collections => _collections;
  List<PlaceEntity> get trendingPlaces => _trendingPlaces;
  List<PlaceEntity> get nearYouPlaces => _nearYouPlaces;
  List<PlaceEntity> get topRatedPlaces => _topRatedPlaces;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> initialize() async {
    _setLoading(true);
    _error = null;

    try {
      _collections = await _getCollectionsUseCase.execute();
      _trendingPlaces = await _getTrendingPlacesUseCase.execute();
      _nearYouPlaces = await _getNearYouPlacesUseCase.execute();
      _topRatedPlaces = await _getTopRatedPlacesUseCase.execute();

      debugPrint('✅ Coleções carregadas: ${_collections.length}');
    } catch (e) {
      _error = 'Erro ao carregar coleções: $e';
      debugPrint('❌ Erro ao carregar coleções: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<List<PlaceEntity>> getCollectionPlaces(String collectionId) async {
    try {
      return await _getCollectionPlacesUseCase.execute(collectionId);
    } catch (e) {
      debugPrint('❌ Erro ao buscar lugares da coleção: $e');
      return [];
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
