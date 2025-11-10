// providers/favorites_provider.dart
import 'package:flutter/foundation.dart';
import '../models/place_model.dart';
import '../core/repositories/favorite_repository.dart';
import '../core/repositories/place_repository.dart';

class FavoritesProvider with ChangeNotifier {
  final FavoriteRepository _favoriteRepo = FavoriteRepository();
  final PlaceRepository _placeRepo = PlaceRepository();

  List<PlaceModel> _favoritePlaces = [];
  List<String> _favoritePlaceIds = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<PlaceModel> get favoritePlaces => _favoritePlaces;
  List<String> get favoritePlaceIds => _favoritePlaceIds;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Carregar favoritos
  Future<void> loadFavorites(String userId) async {
    try {
      _isLoading = true;
      notifyListeners();

      _favoritePlaceIds = await _favoriteRepo.getFavoritePlaceIds(userId);

      // Carregar detalhes dos lugares favoritos
      _favoritePlaces = [];
      for (var placeId in _favoritePlaceIds) {
        final place = await _placeRepo.getById(placeId);
        if (place != null) {
          _favoritePlaces.add(place);
        }
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Toggle favorito
  Future<void> toggleFavorite(String userId, String placeId) async {
    try {
      final isFavorite = await _favoriteRepo.toggleFavorite(userId, placeId);

      if (isFavorite) {
        _favoritePlaceIds.add(placeId);
        final place = await _placeRepo.getById(placeId);
        if (place != null) {
          _favoritePlaces.add(place);
        }
      } else {
        _favoritePlaceIds.remove(placeId);
        _favoritePlaces.removeWhere((p) => p.id == placeId);
      }

      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Verificar se é favorito
  bool isFavorite(String placeId) {
    return _favoritePlaceIds.contains(placeId);
  }

  // Remover favorito
  Future<void> removeFavorite(String userId, String placeId) async {
    try {
      await _favoriteRepo.removeByPlace(userId, placeId);
      _favoritePlaceIds.remove(placeId);
      _favoritePlaces.removeWhere((p) => p.id == placeId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Obter contagem
  Future<int> getFavoritesCount(String userId) async {
    return await _favoriteRepo.getFavoritesCount(userId);
  }
}
