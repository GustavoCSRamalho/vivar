// domain/repositories/location_repository_protocol.dart
import 'package:geolocator/geolocator.dart' as geo;
import 'package:vivar/screens/home/domain/entities/position_entity.dart';

abstract class LocationRepositoryProtocol {
  Position toDomainPosition(geo.Position position);
}
