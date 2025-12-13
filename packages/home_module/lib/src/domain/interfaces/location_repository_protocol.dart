// domain/repositories/location_repository_protocol.dart
import 'package:geolocator/geolocator.dart' as geo;
import '../entity/position_entity.dart';

abstract class LocationRepositoryProtocol {
  Position toDomainPosition(geo.Position position);
}
