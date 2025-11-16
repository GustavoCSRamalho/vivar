// presentation/providers/map_provider.dart

import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:vivar/core/constants/colors.dart';
import 'package:vivar/screens/map/domain/entities/map_place_entity.dart';
import 'package:vivar/screens/map/domain/usecases/map/get_nearby_places_for_map_usecase.dart';
import 'package:vivar/screens/map/domain/usecases/map/get_places_by_category_usecase.dart';
import 'package:vivar/screens/map/domain/usecases/map/get_places_for_map_usecase.dart';
import 'package:vivar/screens/map/domain/usecases/map/search_places_on_map_usecase.dart';

class MapProvider with ChangeNotifier {
  final GetPlacesForMapUseCase _getPlacesForMapUseCase;
  final GetPlacesByCategoryUseCase _getPlacesByCategoryUseCase;
  final GetNearbyPlacesForMapUseCase _getNearbyPlacesForMapUseCase;
  final SearchPlacesOnMapUseCase _searchPlacesOnMapUseCase;

  MapProvider({
    required GetPlacesForMapUseCase getPlacesForMapUseCase,
    required GetPlacesByCategoryUseCase getPlacesByCategoryUseCase,
    required GetNearbyPlacesForMapUseCase getNearbyPlacesForMapUseCase,
    required SearchPlacesOnMapUseCase searchPlacesOnMapUseCase,
  }) : _getPlacesForMapUseCase = getPlacesForMapUseCase,
       _getPlacesByCategoryUseCase = getPlacesByCategoryUseCase,
       _getNearbyPlacesForMapUseCase = getNearbyPlacesForMapUseCase,
       _searchPlacesOnMapUseCase = searchPlacesOnMapUseCase;

  List<MapPlaceEntity> _places = [];
  Set<Marker> _markers = {};
  MapPlaceEntity? _selectedPlace;
  String _selectedCategory = 'Todos';
  bool _isLoading = false;
  String? _error;

  List<MapPlaceEntity> get places => _places;
  Set<Marker> get markers => _markers;
  MapPlaceEntity? get selectedPlace => _selectedPlace;
  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> initialize() async {
    _setLoading(true);
    _error = null;

    try {
      _places = await _getPlacesForMapUseCase.execute();
      _buildMarkers();
      debugPrint('✅ ${_places.length} lugares carregados para o mapa');
    } catch (e) {
      _error = 'Erro ao carregar lugares: $e';
      debugPrint('❌ Erro ao carregar lugares para mapa: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> filterByCategory(String category) async {
    _setLoading(true);
    _selectedCategory = category;

    try {
      _places = await _getPlacesByCategoryUseCase.execute(category);
      _buildMarkers();
      debugPrint('🔍 Filtrado por $category: ${_places.length} lugares');
    } catch (e) {
      _error = 'Erro ao filtrar: $e';
      debugPrint('❌ Erro ao filtrar: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> searchPlaces(String query) async {
    if (query.trim().isEmpty) {
      await initialize();
      return;
    }

    _setLoading(true);

    try {
      _places = await _searchPlacesOnMapUseCase.execute(query);
      _buildMarkers();
      debugPrint('🔍 Busca: ${_places.length} resultados');
    } catch (e) {
      _error = 'Erro na busca: $e';
      debugPrint('❌ Erro na busca: $e');
    } finally {
      _setLoading(false);
    }
  }

  void selectPlace(MapPlaceEntity place) {
    _selectedPlace = place;
    notifyListeners();
  }

  void clearSelection() {
    _selectedPlace = null;
    notifyListeners();
  }

  void _buildMarkers() {
    _markers = _places.map((place) {
      return Marker(
        markerId: MarkerId(place.id),
        position: LatLng(place.latitude, place.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        onTap: () => selectPlace(place),
      );
    }).toSet();
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
