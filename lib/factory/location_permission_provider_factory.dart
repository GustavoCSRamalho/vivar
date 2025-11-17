// presentation/providers/location_permission_provider_factory.dart

import 'package:vivar/screens/location/data/repositories/location_permission_repository_impl.dart';
import 'package:vivar/screens/location/data/usecases/location/check_location_permission_usecase_impl.dart';
import 'package:vivar/screens/location/data/usecases/location/request_location_permission_usecase_impl.dart';
import 'package:vivar/screens/location/presentation/providers/location_permission_provider.dart';

class LocationPermissionProviderFactory {
  static LocationPermissionProvider create() {
    final repository = LocationPermissionRepositoryImpl();

    final requestLocationPermissionUseCase =
        RequestLocationPermissionUseCaseImpl(repository);
    final checkLocationPermissionUseCase = CheckLocationPermissionUseCaseImpl(
      repository,
    );

    return LocationPermissionProvider(
      requestLocationPermissionUseCase: requestLocationPermissionUseCase,
      checkLocationPermissionUseCase: checkLocationPermissionUseCase,
      repository: repository,
    );
  }
}
