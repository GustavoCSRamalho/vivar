// presentation/providers/map_provider.dart

import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:vivar/core/constants/colors.dart';
import 'package:vivar/domain/entity/map/map_place_entity.dart';
import 'package:vivar/domain/usecases/map/get_nearby_places_for_map_usecase.dart';
import 'package:vivar/domain/usecases/map/get_places_by_category_usecase.dart';
import 'package:vivar/domain/usecases/map/get_places_for_map_usecase.dart';
import 'package:vivar/domain/usecases/map/search_places_on_map_usecase.dart';

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

  GoogleMapController? _mapController;
  List<MapPlaceEntity> _businesses = [];
  Set<Marker> _markers = {};
  MapPlaceEntity? _selectedPlace;
  String _selectedCategory = 'Todos';
  bool _isLoading = false;
  String? _error;
  bool _disposed = false;

  // Getters
  GoogleMapController? get mapController => _mapController;
  List<MapPlaceEntity> get businesses => _businesses;
  Set<Marker> get markers => _markers;
  MapPlaceEntity? get selectedPlace => _selectedPlace;
  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isDisposed => _disposed;

  void onMapCreated(GoogleMapController controller) {
    if (_disposed) return;
    _mapController = controller;
    _safeNotify();
  }

  Future<void> initialize() async {
    if (_disposed) return;

    _setLoading(true);
    _error = null;

    try {
      _businesses = await _getPlacesForMapUseCase.execute();
      _buildMarkers();
      debugPrint('✅ ${_businesses.length} lugares carregados para o mapa');
    } catch (e) {
      _error = 'Erro ao carregar lugares: $e';
      debugPrint('❌ Erro ao carregar lugares para mapa: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadNearbyPlaces(double latitude, double longitude) async {
    if (_disposed) return;

    _setLoading(true);
    _error = null;

    try {
      _businesses = await _getNearbyPlacesForMapUseCase.execute(
        latitude: latitude,
        longitude: longitude,
        radiusKm: 5000,
      );
      _buildMarkers();
      debugPrint('✅ ${_businesses.length} lugares próximos carregados');
    } catch (e) {
      _error = 'Erro ao carregar lugares próximos: $e';
      debugPrint('❌ Erro ao carregar lugares próximos: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> filterByCategory(String category) async {
    if (_disposed) return;

    _setLoading(true);
    _selectedCategory = category;

    try {
      _businesses = await _getPlacesByCategoryUseCase.execute(category);
      _buildMarkers();
      debugPrint('🔍 Filtrado por $category: ${_businesses.length} lugares');
    } catch (e) {
      _error = 'Erro ao filtrar: $e';
      debugPrint('❌ Erro ao filtrar: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> searchPlaces(
    String query,
    double latitude,
    double longitude,
  ) async {
    if (_disposed) return;

    if (query.trim().isEmpty) {
      await loadNearbyPlaces(latitude, longitude);
      return;
    }

    _setLoading(true);

    try {
      _businesses = await _searchPlacesOnMapUseCase.execute(query);
      _buildMarkers();
      debugPrint('🔍 Busca: ${_businesses.length} resultados');
    } catch (e) {
      _error = 'Erro na busca: $e';
      debugPrint('❌ Erro na busca: $e');
    } finally {
      _setLoading(false);
    }
  }

  void selectPlace(MapPlaceEntity? place) {
    if (_disposed) return;
    _selectedPlace = place;
    _safeNotify();
  }

  void clearSelection() {
    if (_disposed) return;
    _selectedPlace = null;
    _safeNotify();
  }

  Future<void> animateToPlace(MapPlaceEntity place) async {
    if (_disposed || _mapController == null) return;

    try {
      await _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(place.latitude, place.longitude),
          16.0,
        ),
      );
    } catch (e) {
      debugPrint('⚠️ Erro ao animar câmera: $e');
    }
  }

  void _buildMarkers() {
    if (_disposed) return;

    _markers = _businesses.map((place) {
      return Marker(
        markerId: MarkerId(place.id),
        position: LatLng(place.latitude, place.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        onTap: () => selectPlace(place),
      );
    }).toSet();
    _safeNotify();
  }

  void _setLoading(bool value) {
    if (_disposed) return;
    _isLoading = value;
    _safeNotify();
  }

  void _safeNotify() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    debugPrint('🗑️ MapProvider dispose chamado');
    _disposed = true;

    // Dispose do controller de forma segura
    try {
      _mapController?.dispose();
    } catch (e) {
      debugPrint('⚠️ Erro ao fazer dispose do MapController: $e');
    }

    _mapController = null;
    _markers.clear();
    _businesses.clear();
    _selectedPlace = null;

    super.dispose();
    debugPrint('✅ MapProvider disposed com sucesso');
  }
}
