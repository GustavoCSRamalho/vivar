// data/repositories/location_repository_impl.dart

import 'package:vivar/screens/home/domain/entities/position_entity.dart';

import '../../domain/repositories/location_repository_protocol.dart';

import 'package:geolocator/geolocator.dart' as geo;

/// Implementação do LocationRepositoryProtocol
///
/// Adapta o LocationService existente para o protocolo da camada de domínio

class LocationRepositoryImpl implements LocationRepositoryProtocol {
  @override
  Position toDomainPosition(geo.Position geoPosition) {
    return Position(
      latitude: geoPosition.latitude,
      longitude: geoPosition.longitude,
      accuracy: geoPosition.accuracy,
      timestamp: geoPosition.timestamp,
    );
  }
}
