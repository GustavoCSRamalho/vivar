// presentation/providers/location_permission_provider_factory.dart

import '../data/datasource/location_permission_datasource.dart';
import '../data/repositories/location_permission_repository_impl.dart';
import '../data/usecases/location/check_location_permission_usecase_impl.dart';
import '../data/usecases/location/request_location_permission_usecase_impl.dart';
import '../presentation/providers/location_permission_provider.dart';

class LocationPermissionProviderFactory {
  static LocationPermissionProvider create() {
    final datasource = LocationPermissionDatasourceImpl();
    final repository = LocationPermissionRepositoryImpl(datasource: datasource);

    final requestLocationPermissionUseCase = RequestLocationPermissionUseCase(
      repository,
    );
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
