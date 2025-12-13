// presentation/providers/discover_provider.dart

import 'package:discover_module/src/domain/entity/business_entity.dart';
import 'package:discover_module/src/domain/entity/discover_collection_entity.dart';
import 'package:discover_module/src/domain/usecases/get_collection_places_usecase.dart';
import 'package:discover_module/src/domain/usecases/get_collections_usecase.dart';
import 'package:discover_module/src/domain/usecases/get_near_you_places_usecase.dart';
import 'package:discover_module/src/domain/usecases/get_top_rated_places_usecase.dart';
import 'package:discover_module/src/domain/usecases/get_trending_places_usecase.dart';
import 'package:flutter/foundation.dart';

class DiscoverProvider with ChangeNotifier {
  final GetCollectionsUseCase _getCollectionsUseCase;
  final GetCollectionBusinessesUseCase _getCollectionBusinessesUseCase;
  final GetTrendingBusinessesUseCase _getTrendingBusinessesUseCase;
  final GetNearYouBusinessesUseCase _getNearYouBusinessesUseCase;
  final GetTopRatedBusinessesUseCase _getTopRatedBusinessesUseCase;

  DiscoverProvider({
    required GetCollectionsUseCase getCollectionsUseCase,
    required GetCollectionBusinessesUseCase getCollectionBusinessesUseCase,
    required GetTrendingBusinessesUseCase getTrendingBusinessesUseCase,
    required GetNearYouBusinessesUseCase getNearYouBusinessesUseCase,
    required GetTopRatedBusinessesUseCase getTopRatedBusinessesUseCase,
  }) : _getCollectionsUseCase = getCollectionsUseCase,
       _getCollectionBusinessesUseCase = getCollectionBusinessesUseCase,
       _getTrendingBusinessesUseCase = getTrendingBusinessesUseCase,
       _getNearYouBusinessesUseCase = getNearYouBusinessesUseCase,
       _getTopRatedBusinessesUseCase = getTopRatedBusinessesUseCase;

  List<DiscoverCollectionEntity> _collections = [];
  List<BusinessEntity> _trendingBusinesses = [];
  List<BusinessEntity> _nearYouBusinesses = [];
  List<BusinessEntity> _topRatedBusinesses = [];
  bool _isLoading = false;
  String? _error;

  List<DiscoverCollectionEntity> get collections => _collections;
  List<BusinessEntity> get trendingBusinesses => _trendingBusinesses;
  List<BusinessEntity> get nearYouBusinesses => _nearYouBusinesses;
  List<BusinessEntity> get topRatedBusinesses => _topRatedBusinesses;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> initialize() async {
    _setLoading(true);
    _error = null;

    try {
      _collections = await _getCollectionsUseCase.execute();
      _trendingBusinesses = await _getTrendingBusinessesUseCase.execute();
      _nearYouBusinesses = await _getNearYouBusinessesUseCase.execute();
      _topRatedBusinesses = await _getTopRatedBusinessesUseCase.execute();

      debugPrint('✅ Coleções carregadas: ${_collections.length}');
    } catch (e) {
      _error = 'Erro ao carregar coleções: $e';
      debugPrint('❌ Erro ao carregar coleções: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<List<BusinessEntity>> getCollectionBusinesses(
    String collectionId,
  ) async {
    try {
      return await _getCollectionBusinessesUseCase.execute(collectionId);
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
