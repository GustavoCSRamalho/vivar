// domain/repositories/location_permission_repository_protocol.dart

import '../usecases/location/request_location_permission_usecase.dart';

abstract class LocationPermissionRepositoryProtocol {
  Future<LocationPermissionResult> requestPermission();
  Future<bool> hasPermission();
  Future<void> openSettings();
}
