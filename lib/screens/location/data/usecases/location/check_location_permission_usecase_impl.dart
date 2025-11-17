// data/usecases/location/check_location_permission_usecase_impl.dart

import 'package:vivar/screens/location/domain/repositories/location_permission_repository_protocol.dart';
import 'package:vivar/screens/location/domain/usecases/location/check_location_permission_usecase.dart';

class CheckLocationPermissionUseCaseImpl
    implements CheckLocationPermissionUseCase {
  final LocationPermissionRepositoryProtocol _repository;

  CheckLocationPermissionUseCaseImpl(this._repository);

  @override
  Future<bool> execute() async {
    try {
      return await _repository.hasPermission();
    } catch (e) {
      print('❌ Erro ao verificar permissão: $e');
      return false;
    }
  }
}
