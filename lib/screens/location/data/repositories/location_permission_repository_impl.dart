// data/repositories/location_permission_repository_impl.dart

import 'package:permission_handler/permission_handler.dart';
import 'package:vivar/domain/interface/location/location_permission_repository_protocol.dart';
import 'package:vivar/domain/interface/location/request_location_permission_protocol.dart';

class LocationPermissionRepositoryImpl
    implements LocationPermissionRepositoryProtocol {
  @override
  Future<LocationPermissionResult> requestPermission() async {
    try {
      final status = await Permission.location.request();

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
    } catch (e) {
      print('❌ Erro ao solicitar permissão de localização: $e');
      return LocationPermissionResult.denied;
    }
  }

  @override
  Future<bool> hasPermission() async {
    try {
      final status = await Permission.location.status;
      return status.isGranted || status.isLimited;
    } catch (e) {
      print('❌ Erro ao verificar permissão: $e');
      return false;
    }
  }

  @override
  Future<void> openSettings() async {
    try {
      await openAppSettings();
    } catch (e) {
      print('❌ Erro ao abrir configurações: $e');
    }
  }
}
