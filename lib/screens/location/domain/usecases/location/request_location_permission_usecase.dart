// domain/usecases/location/request_location_permission_usecase.dart

abstract class RequestLocationPermissionUseCase {
  Future<LocationPermissionResult> execute();
}

enum LocationPermissionResult { granted, denied, permanentlyDenied, restricted }
