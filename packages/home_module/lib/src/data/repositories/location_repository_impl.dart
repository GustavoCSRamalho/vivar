// data/repositories/location_repository_impl.dart

import 'package:geolocator/geolocator.dart' as geo;
import 'package:home_module/src/domain/interfaces/location_repository_protocol.dart';
import '../../domain/entity/position_entity.dart';
import '../datasource/location_datasource.dart';

/// Implementação do LocationRepositoryProtocol
/// Delega operações de conversão para o datasource
/// Responsável por adaptar geo.Position para Position (domain entity)
class LocationRepositoryImpl implements LocationRepositoryProtocol {
  final LocationDatasourceProtocol _datasource;

  LocationRepositoryImpl({required LocationDatasourceProtocol datasource})
    : _datasource = datasource;

  @override
  Position toDomainPosition(geo.Position geoPosition) {
    // Converte através do datasource (se houver processamento necessário)
    final processedPosition = _datasource.convertGeolocatorPosition(
      geoPosition,
    );

    // Converte para a entidade de domínio
    return _geoPositionToEntity(processedPosition);
  }

  /// Converte geo.Position (data layer) para Position (domain layer)
  Position _geoPositionToEntity(geo.Position geoPosition) {
    return Position(
      latitude: geoPosition.latitude,
      longitude: geoPosition.longitude,
      accuracy: geoPosition.accuracy,
      timestamp: geoPosition.timestamp,
    );
  }
}
