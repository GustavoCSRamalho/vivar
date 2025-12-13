// data/datasources/location/location_permission_datasource_protocol.dart

import 'package:location_module/src/domain/interfaces/request_location_permission_protocol.dart';
import 'package:permission_handler/permission_handler.dart';

abstract class LocationPermissionDatasourceProtocol {
  Future<LocationPermissionResult> requestPermission();
  Future<bool> checkPermissionStatus();
  Future<void> openAppSettings();
}

class LocationPermissionDatasourceImpl
    implements LocationPermissionDatasourceProtocol {
  @override
  Future<LocationPermissionResult> requestPermission() async {
    try {
      final status = await Permission.location.request();
      return _mapPermissionStatusToResult(status);
    } catch (e) {
      print('❌ Erro ao solicitar permissão de localização: $e');
      return LocationPermissionResult.denied;
    }
  }

  @override
  Future<bool> checkPermissionStatus() async {
    try {
      final status = await Permission.location.status;
      return _isPermissionGranted(status);
    } catch (e) {
      print('❌ Erro ao verificar permissão: $e');
      return false;
    }
  }

  @override
  Future<void> openAppSettings() async {
    try {
      await openAppSettings();
    } catch (e) {
      print('❌ Erro ao abrir configurações: $e');
      rethrow;
    }
  }

  /// Mapeia o status da permissão do permission_handler para o resultado do domínio
  LocationPermissionResult _mapPermissionStatusToResult(
    PermissionStatus status,
  ) {
    switch (status) {
      case PermissionStatus.granted:
      case PermissionStatus.limited:
        return LocationPermissionResult.granted;
      case PermissionStatus.denied:
        return LocationPermissionResult.denied;
      case PermissionStatus.permanentlyDenied:
        return LocationPermissionResult.permanentlyDenied;
      case PermissionStatus.restricted:
        return LocationPermissionResult.restricted;
      default:
        return LocationPermissionResult.denied;
    }
  }

  /// Verifica se a permissão está concedida (granted ou limited)
  bool _isPermissionGranted(PermissionStatus status) {
    return status.isGranted || status.isLimited;
  }
}
