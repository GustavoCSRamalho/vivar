// // providers/places_provider.dart
// import 'package:flutter/foundation.dart';
// import 'package:vivar/screens/home/data/models/place_model.dart';
// import '../core/repositories/place_repository.dart';
// import '../core/repositories/favorite_repository.dart';

// class PlacesProvider with ChangeNotifier {
//   final PlaceRepository _placeRepo = PlaceRepository();
//   final FavoriteRepository _favoriteRepo = FavoriteRepository();

//   List<PlaceModel> _places = [];
//   List<PlaceModel> _filteredPlaces = [];
//   List<String> _favoritePlaceIds = [];
//   bool _isLoading = false;
//   String? _error;

//   // Filtros
//   String? _selectedCategory;
//   String? _searchQuery;
//   double? _userLatitude;
//   double? _userLongitude;

//   // Getters
//   List<PlaceModel> get places => _filteredPlaces;
//   List<String> get favoritePlaceIds => _favoritePlaceIds;
//   bool get isLoading => _isLoading;
//   String? get error => _error;
//   String? get selectedCategory => _selectedCategory;

//   // Inicializar
//   Future<void> initialize(String userId) async {
//     await loadPlaces();
//     await loadFavorites(userId);
//   }

//   // Carregar lugares
//   Future<void> loadPlaces() async {
//     try {
//       _isLoading = true;
//       _error = null;
//       notifyListeners();

//       _places = await _placeRepo.getAll();
//       debugPrint('⚠️ placesProvider.loadNearbyPlaces ${_places}');
//       _applyFilters();

//       _isLoading = false;
//       notifyListeners();
//     } catch (e) {
//       _error = e.toString();
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   // Carregar favoritos
//   Future<void> loadFavorites(String userId) async {
//     try {
//       _favoritePlaceIds = await _favoriteRepo.getFavoritePlaceIds(userId);
//       notifyListeners();
//     } catch (e) {
//       debugPrint('Erro ao carregar favoritos: $e');
//     }
//   }

//   // Buscar lugares próximos
//   Future<void> loadNearbyPlaces(
//     double latitude,
//     double longitude, {
//     double radiusKm = 5.0,
//   }) async {
//     try {
//       _isLoading = true;
//       _error = null;
//       _userLatitude = latitude;
//       _userLongitude = longitude;
//       notifyListeners();

//       _places = await _placeRepo.getNearby(latitude, longitude, radiusKm);
//       _applyFilters();

//       _isLoading = false;
//       notifyListeners();
//     } catch (e) {
//       _error = e.toString();
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   // Buscar por texto
//   Future<void> searchPlaces(String query) async {
//     _searchQuery = query;
//     if (query.isEmpty) {
//       _filteredPlaces = _places;
//     } else {
//       try {
//         _filteredPlaces = await _placeRepo.search(query);
//       } catch (e) {
//         _error = e.toString();
//       }
//     }
//     notifyListeners();
//   }

//   // Filtrar por categoria
//   void filterByCategory(String? category) {
//     _selectedCategory = category;
//     _applyFilters();
//     notifyListeners();
//   }

//   // Aplicar filtros
//   void _applyFilters() {
//     _filteredPlaces = _places;

//     if (_selectedCategory != null && _selectedCategory != 'Todos') {
//       _filteredPlaces = _filteredPlaces
//           .where((place) => place.category == _selectedCategory)
//           .toList();
//     }

//     if (_searchQuery != null && _searchQuery!.isNotEmpty) {
//       _filteredPlaces = _filteredPlaces.where((place) {
//         return place.name.toLowerCase().contains(_searchQuery!.toLowerCase()) ||
//             place.description?.toLowerCase().contains(
//                   _searchQuery!.toLowerCase(),
//                 ) ==
//                 true;
//       }).toList();
//     }
//   }

//   // Filtros avançados
//   Future<void> applyAdvancedFilters({
//     List<String>? categories,
//     String? priceRange,
//     double? minRating,
//     List<String>? amenities,
//     bool? openNow,
//   }) async {
//     try {
//       _isLoading = true;
//       notifyListeners();

//       _filteredPlaces = await _placeRepo.getFiltered(
//         categories: categories,
//         priceRange: priceRange,
//         minRating: minRating,
//         amenities: amenities,
//         openNow: openNow,
//       );

//       _isLoading = false;
//       notifyListeners();
//     } catch (e) {
//       _error = e.toString();
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   // Lugares com desconto
//   Future<void> loadPlacesWithDiscount() async {
//     try {
//       _isLoading = true;
//       notifyListeners();

//       _filteredPlaces = await _placeRepo.getPlacesWithDiscount();

//       _isLoading = false;
//       notifyListeners();
//     } catch (e) {
//       _error = e.toString();
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   // Top avaliados
//   Future<void> loadTopRated({int limit = 10}) async {
//     try {
//       _isLoading = true;
//       notifyListeners();

//       _filteredPlaces = await _placeRepo.getTopRated(limit: limit);

//       _isLoading = false;
//       notifyListeners();
//     } catch (e) {
//       _error = e.toString();
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   // Adicionar lugar
//   Future<void> addPlace(PlaceModel place) async {
//     try {
//       await _placeRepo.insert(place);
//       await loadPlaces();
//     } catch (e) {
//       _error = e.toString();
//       notifyListeners();
//     }
//   }

//   // Atualizar lugar
//   Future<void> updatePlace(PlaceModel place) async {
//     try {
//       await _placeRepo.update(place);
//       await loadPlaces();
//     } catch (e) {
//       _error = e.toString();
//       notifyListeners();
//     }
//   }

//   // Obter lugar por ID
//   Future<PlaceModel?> getPlaceById(String id) async {
//     return await _placeRepo.getById(id);
//   }

//   // Toggle favorito
//   Future<void> toggleFavorite(String userId, String placeId) async {
//     try {
//       final isFavorite = await _favoriteRepo.toggleFavorite(userId, placeId);

//       if (isFavorite) {
//         if (!_favoritePlaceIds.contains(placeId)) {
//           _favoritePlaceIds.add(placeId);
//         }
//       } else {
//         _favoritePlaceIds.remove(placeId);
//       }

//       notifyListeners();
//     } catch (e) {
//       debugPrint('Erro ao alternar favorito: $e');
//     }
//   }

//   Future<void> addFavorite(String userId, String placeId) async {
//     try {
//       await _favoriteRepo.addFavorite(userId, placeId);

//       // Adicionar à lista local
//       if (!_favoritePlaceIds.contains(placeId)) {
//         _favoritePlaceIds.add(placeId);
//         notifyListeners();
//       }
//     } catch (e) {
//       debugPrint('Erro ao adicionar favorito: $e');
//     }
//   }

//   // Verificar se é favorito
//   bool isFavorite(String placeId) {
//     return _favoritePlaceIds.contains(placeId);
//   }

//   // Limpar filtros
//   void clearFilters() {
//     _selectedCategory = null;
//     _searchQuery = null;
//     _applyFilters();
//     notifyListeners();
//   }
// }
