// core/services/location_service.dart
import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  Position? _currentPosition;
  String? _currentAddress;

  // Getters
  Position? get currentPosition => _currentPosition;
  String? get currentAddress => _currentAddress;

  // ========== PERMISSÕES ==========

  /// Verifica se a permissão de localização foi concedida
  Future<bool> hasPermission() async {
    final status = await Permission.location.status;
    return status.isGranted;
  }

  /// Solicita permissão de localização
  Future<bool> requestPermission() async {
    try {
      final status = await Permission.location.request();

      if (status.isGranted) {
        debugPrint('✅ Permissão de localização concedida');
        return true;
      } else if (status.isDenied) {
        debugPrint('❌ Permissão de localização negada');
        return false;
      } else if (status.isPermanentlyDenied) {
        debugPrint('❌ Permissão de localização permanentemente negada');
        // Abrir configurações
        await openAppSettings();
        return false;
      }

      return false;
    } catch (e) {
      debugPrint('❌ Erro ao solicitar permissão: $e');
      return false;
    }
  }

  /// Verifica se o serviço de localização está habilitado
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Abre as configurações de localização do dispositivo
  Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  // ========== OBTER LOCALIZAÇÃO ==========

  /// Obtém a localização atual do usuário
  Future<Position?> getCurrentLocation() async {
    try {
      // Verifica se o serviço de localização está habilitado
      bool serviceEnabled = await isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint('❌ Serviço de localização desabilitado');
        return null;
      }

      // Verifica permissão
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          debugPrint('❌ Permissão de localização negada');
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        debugPrint('❌ Permissão de localização permanentemente negada');
        return null;
      }

      // Obtém a posição
      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      debugPrint(
        '✅ Localização obtida: ${_currentPosition?.latitude}, ${_currentPosition?.longitude}',
      );

      return _currentPosition;
    } catch (e) {
      debugPrint('❌ Erro ao obter localização: $e');
      return null;
    }
  }

  /// Obtém a localização com precisão específica
  Future<Position?> getCurrentLocationWithAccuracy(
    LocationAccuracy accuracy,
  ) async {
    try {
      bool serviceEnabled = await isLocationServiceEnabled();
      if (!serviceEnabled) return null;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return null;
      }

      if (permission == LocationPermission.deniedForever) return null;

      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: accuracy,
      );

      return _currentPosition;
    } catch (e) {
      debugPrint('❌ Erro ao obter localização: $e');
      return null;
    }
  }

  /// Obtém a última localização conhecida (mais rápido, mas pode ser antiga)
  Future<Position?> getLastKnownLocation() async {
    try {
      _currentPosition = await Geolocator.getLastKnownPosition();
      return _currentPosition;
    } catch (e) {
      debugPrint('❌ Erro ao obter última localização: $e');
      return null;
    }
  }

  // ========== STREAM DE LOCALIZAÇÃO ==========

  /// Stream que emite atualizações de localização em tempo real
  Stream<Position> getLocationStream({
    LocationAccuracy accuracy = LocationAccuracy.high,
    int distanceFilter = 10, // metros
    int timeLimit = 5000, // milissegundos
  }) {
    final locationSettings = LocationSettings(
      accuracy: accuracy,
      distanceFilter: distanceFilter,
      timeLimit: Duration(milliseconds: timeLimit),
    );

    return Geolocator.getPositionStream(locationSettings: locationSettings);
  }

  // ========== GEOCODING (Coordenadas ↔ Endereço) ==========

  /// Converte coordenadas em endereço (Reverse Geocoding)
  Future<String?> getAddressFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];

        // Formato: Rua, Bairro, Cidade - Estado
        _currentAddress = [
          place.street,
          place.subLocality,
          '${place.locality} - ${place.administrativeArea}',
        ].where((part) => part != null && part.isNotEmpty).join(', ');

        debugPrint('✅ Endereço obtido: $_currentAddress');
        return _currentAddress;
      }

      return null;
    } catch (e) {
      debugPrint('❌ Erro ao obter endereço: $e');
      return null;
    }
  }

  /// Converte coordenadas em cidade
  Future<String?> getCityFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        return '${place.locality}, ${place.administrativeArea}';
      }

      return null;
    } catch (e) {
      debugPrint('❌ Erro ao obter cidade: $e');
      return null;
    }
  }

  /// Converte endereço em coordenadas (Geocoding)
  Future<Position?> getCoordinatesFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);

      if (locations.isNotEmpty) {
        Location location = locations[0];

        return Position(
          latitude: location.latitude,
          longitude: location.longitude,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0,
          altitudeAccuracy: 0,
          headingAccuracy: 0,
        );
      }

      return null;
    } catch (e) {
      debugPrint('❌ Erro ao obter coordenadas: $e');
      return null;
    }
  }

  // ========== CÁLCULOS DE DISTÂNCIA ==========

  /// Calcula a distância entre duas coordenadas em metros
  double getDistanceBetween(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  /// Calcula a distância entre a posição atual e outra coordenada
  double? getDistanceFromCurrent(double latitude, double longitude) {
    if (_currentPosition == null) return null;

    return getDistanceBetween(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
      latitude,
      longitude,
    );
  }

  /// Calcula o bearing (direção) entre duas coordenadas
  double getBearingBetween(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return Geolocator.bearingBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  // ========== MÉTODOS AUXILIARES ==========

  /// Formata a distância de metros para string legível
  String formatDistance(double distanceInMeters) {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.toStringAsFixed(0)}m';
    } else {
      return '${(distanceInMeters / 1000).toStringAsFixed(1)}km';
    }
  }

  /// Verifica se uma coordenada está dentro de um raio (em metros)
  bool isWithinRadius(
    double centerLat,
    double centerLng,
    double targetLat,
    double targetLng,
    double radiusInMeters,
  ) {
    double distance = getDistanceBetween(
      centerLat,
      centerLng,
      targetLat,
      targetLng,
    );

    return distance <= radiusInMeters;
  }

  /// Verifica se a localização atual está dentro de um raio
  bool? isCurrentLocationWithinRadius(
    double targetLat,
    double targetLng,
    double radiusInMeters,
  ) {
    if (_currentPosition == null) return null;

    return isWithinRadius(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
      targetLat,
      targetLng,
      radiusInMeters,
    );
  }

  /// Obtém a precisão da localização atual
  String? getAccuracyDescription() {
    if (_currentPosition == null) return null;

    final accuracy = _currentPosition!.accuracy;

    if (accuracy <= 10) return 'Excelente';
    if (accuracy <= 50) return 'Boa';
    if (accuracy <= 100) return 'Razoável';
    return 'Baixa';
  }

  // ========== LIMPEZA ==========

  /// Limpa os dados de localização armazenados
  void clear() {
    _currentPosition = null;
    _currentAddress = null;
  }
}

// ========== MODELOS AUXILIARES ==========

/// Classe para representar uma região geográfica
class LocationRegion {
  final double latitude;
  final double longitude;
  final double radius; // em metros

  LocationRegion({
    required this.latitude,
    required this.longitude,
    required this.radius,
  });

  /// Verifica se uma posição está dentro da região
  bool contains(Position position) {
    final distance = Geolocator.distanceBetween(
      latitude,
      longitude,
      position.latitude,
      position.longitude,
    );

    return distance <= radius;
  }
}

/// Classe para representar um resultado de busca de localização
class LocationSearchResult {
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final double? distance; // distância da posição atual em metros

  LocationSearchResult({
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.distance,
  });
}
