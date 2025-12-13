// presentation/providers/home_provider.dart

import 'package:flutter/foundation.dart';
import 'package:home_module/src/domain/entity/business_entity.dart';
import 'package:home_module/src/domain/entity/position_entity.dart';
import 'package:home_module/src/domain/entity/user_entity.dart';
import 'package:home_module/src/domain/usecases/apply_advanced_filters_usecase.dart';
import 'package:home_module/src/domain/usecases/check_unread_notifications_usecase.dart';
import 'package:home_module/src/domain/usecases/filter_places_by_category_usecase.dart';
import 'package:home_module/src/domain/usecases/get_all_businesses_usecase.dart';
import 'package:home_module/src/domain/usecases/get_current_location_usecase.dart';
import 'package:home_module/src/domain/usecases/get_current_user_usecase.dart';
import 'package:home_module/src/domain/usecases/get_nearby_places_usecase.dart';
import 'package:home_module/src/domain/usecases/get_notifications_usecase.dart';
import 'package:home_module/src/domain/usecases/load_user_favorites_usecase.dart';
import 'package:home_module/src/domain/usecases/search_places_usecase.dart';
import 'package:home_module/src/domain/usecases/toggle_favorite_place_usecase.dart';

/// Provider para a Home Screen
///
/// Responsabilidade: Gerenciar o estado da tela Home
/// Usa UseCases para toda a lógica de negócio
class HomeProvider with ChangeNotifier {
  // Use Cases injetados
  final GetCurrentLocationUseCase _getCurrentLocationUseCase;
  final GetAllBusinessesUseCase _getAllBusinessesUseCase;
  final GetNearbyBusinessesUseCase _getNearbyBusinessesUseCase;
  final FilterBusinessesByCategoryUseCase _filterBusinessesByCategoryUseCase;
  final SearchBusinessesUseCase _searchBusinessesUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final LoadUserFavoritesUseCase _loadUserFavoritesUseCase;
  final ToggleFavoriteBusinessesUseCase _toggleFavoritePlaceUseCase;
  final GetNotificationsUseCase _getNotificationsUseCase;
  final CheckUnreadNotificationsUseCase _checkUnreadNotificationsUseCase;
  final ApplyAdvancedFiltersUseCase _applyAdvancedFiltersUseCase;

  HomeProvider({
    required GetCurrentLocationUseCase getCurrentLocationUseCase,
    required GetAllBusinessesUseCase getAllBusinessesUseCase,
    required GetNearbyBusinessesUseCase getNearbyBusinessesUseCase,
    required FilterBusinessesByCategoryUseCase
    filterBusinessesByCategoryUseCase,
    required SearchBusinessesUseCase searchBusinessesUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required LoadUserFavoritesUseCase loadUserFavoritesUseCase,
    required ToggleFavoriteBusinessesUseCase toggleFavoriteBusinessesUseCase,
    required GetNotificationsUseCase getNotificationsUseCase,
    required CheckUnreadNotificationsUseCase checkUnreadNotificationsUseCase,
    required ApplyAdvancedFiltersUseCase applyAdvancedFiltersUseCase,
  }) : _getCurrentLocationUseCase = getCurrentLocationUseCase,
       _getAllBusinessesUseCase = getAllBusinessesUseCase,
       _getNearbyBusinessesUseCase = getNearbyBusinessesUseCase,
       _filterBusinessesByCategoryUseCase = filterBusinessesByCategoryUseCase,
       _searchBusinessesUseCase = searchBusinessesUseCase,
       _getCurrentUserUseCase = getCurrentUserUseCase,
       _loadUserFavoritesUseCase = loadUserFavoritesUseCase,
       _toggleFavoritePlaceUseCase = toggleFavoriteBusinessesUseCase,
       _getNotificationsUseCase = getNotificationsUseCase,
       _checkUnreadNotificationsUseCase = checkUnreadNotificationsUseCase,
       _applyAdvancedFiltersUseCase = applyAdvancedFiltersUseCase;

  // Estado
  List<BusinessEntity> _allBusinesses = [];
  List<BusinessEntity> _filteredBusinesses = [];
  List<String> _favoritePlaceIds = [];
  UserEntity? _currentUser;
  Position? _currentPosition;
  int _unreadNotificationsCount = 0;

  bool _isLoading = false;
  String? _error;
  String _selectedCategory = 'Todos';

  // Getters
  List<BusinessEntity> get businesses => _filteredBusinesses;
  List<String> get favoritePlaceIds => _favoritePlaceIds;
  UserEntity? get currentUser => _currentUser;
  Position? get currentPosition => _currentPosition;
  int get unreadNotificationsCount => _unreadNotificationsCount;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get selectedCategory => _selectedCategory;
  bool get hasUnreadNotifications => _unreadNotificationsCount > 0;
  String get userLocation => _currentUser?.displayLocation ?? 'São Paulo, SP';

  /// Inicializa os dados da Home
  Future<void> initialize() async {
    debugPrint('🔄 Inicializando HomeProvider...');

    _setLoading(true);
    _error = null;

    try {
      // 1. Carregar usuário
      await _loadUser();

      // 2. Obter localização
      await _loadLocation();

      // 3. Carregar lugares (próximos se houver localização, todos caso contrário)
      await _loadBusinesses();

      // 4. Carregar favoritos se houver usuário
      if (_currentUser != null) {
        await _loadFavorites();
        await _loadUnreadNotifications();
      }

      debugPrint('✅ HomeProvider inicializado com sucesso');
    } catch (e) {
      _error = 'Erro ao carregar dados: $e';
      debugPrint('❌ Erro na inicialização: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Carrega o usuário atual
  Future<void> _loadUser() async {
    try {
      _currentUser = await _getCurrentUserUseCase.execute();
      debugPrint('✅ Usuário carregado: ${_currentUser?.name}');
    } catch (e) {
      debugPrint('❌ Erro ao carregar usuário: $e');
    }
  }

  /// Carrega a localização atual
  Future<void> _loadLocation() async {
    try {
      _currentPosition = await _getCurrentLocationUseCase.execute();

      if (_currentPosition != null) {
        debugPrint(
          '📍 Localização obtida: ${_currentPosition!.latitude}, ${_currentPosition!.longitude}',
        );
      } else {
        debugPrint('⚠️ Localização não disponível');
      }
    } catch (e) {
      debugPrint('❌ Erro ao obter localização: $e');
    }
  }

  /// Carrega os lugares
  Future<void> _loadBusinesses() async {
    try {
      if (_currentPosition != null) {
        // Carregar lugares próximos
        debugPrint('📍 Carregando lugares próximos...');
        _allBusinesses = await _getNearbyBusinessesUseCase.execute(
          userLatitude: _currentPosition!.latitude,
          userLongitude: _currentPosition!.longitude,
          radiusKm: 5.0,
        );
      } else {
        // Carregar todos os lugares
        debugPrint('🌍 Carregando todos os lugares...');
        _allBusinesses = await _getAllBusinessesUseCase.execute();
      }

      _applyFilter();
      debugPrint('✅ ${_allBusinesses.length} lugares carregados');
    } catch (e) {
      throw Exception('Erro ao carregar lugares: $e');
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

  /// Carrega contagem de notificações não lidas
  Future<void> _loadUnreadNotifications() async {
    if (_currentUser == null) return;

    try {
      _unreadNotificationsCount = await _checkUnreadNotificationsUseCase
          .execute(_currentUser!.id);
      debugPrint('✅ ${_unreadNotificationsCount} notificações não lidas');
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Erro ao carregar notificações: $e');
    }
  }

  /// Filtra lugares por categoria
  void filterByCategory(String category) {
    debugPrint('🔍 Filtrando por categoria: $category');
    _selectedCategory = category;
    _applyFilter();
    notifyListeners();
  }

  /// Aplica o filtro atual
  void _applyFilter() {
    _filteredBusinesses = _filterBusinessesByCategoryUseCase.execute(
      businesses: _allBusinesses,
      category: _selectedCategory,
    );
    debugPrint('✅ Filtro aplicado: ${_filteredBusinesses.length} lugares');
  }

  void applyAdvancedFilters({
    List<String>? categories,
    String? priceRange,
    double? minRating,
    List<String>? amenities,
    bool? openNow,
  }) async {
    _filteredBusinesses = await _applyAdvancedFiltersUseCase.execute(
      categories: categories,
      priceRange: priceRange,
      minRating: minRating,
      amenities: amenities,
      openNow: openNow,
    );
    debugPrint('✅ Filtro aplicado: ${_filteredBusinesses.length} lugares');
  }

  /// Busca lugares por texto
  Future<void> searchBusinesses(String query) async {
    if (query.trim().isEmpty) {
      _filteredBusinesses = _allBusinesses;
      notifyListeners();
      return;
    }

    _setLoading(true);

    try {
      _filteredBusinesses = await _searchBusinessesUseCase.execute(query);
      debugPrint(
        '🔍 Busca: ${_filteredBusinesses.length} resultados para "$query"',
      );
    } catch (e) {
      _error = 'Erro na busca: $e';
      debugPrint('❌ Erro na busca: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Alterna favorito
  Future<void> toggleFavorite(String placeId) async {
    if (_currentUser == null) return;

    try {
      final isFavorite = await _toggleFavoritePlaceUseCase.execute(
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

  /// Verifica se um lugar é favorito
  bool isFavorite(String placeId) {
    return _favoritePlaceIds.contains(placeId);
  }

  /// Recarrega todos os dados
  Future<void> refresh() async {
    await initialize();
  }

  /// Limpa o filtro
  void clearFilter() {
    _selectedCategory = 'Todos';
    _applyFilter();
    notifyListeners();
  }

  /// Define estado de loading
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
