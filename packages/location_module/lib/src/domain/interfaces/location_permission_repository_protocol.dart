// domain/repositories/location_permission_repository_protocol.dart

import 'request_location_permission_protocol.dart';

abstract class LocationPermissionRepositoryProtocol {
  Future<LocationPermissionResult> requestPermission();
  Future<bool> hasPermission();
  Future<void> openSettings();
}
