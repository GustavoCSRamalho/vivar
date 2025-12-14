import 'package:core_module/core_module.dart';
import 'package:flutter/material.dart';

class NavigationHelpers {
  NavigationHelpers._();

  /// Navega para detalhes do negócio
  static Future<T?> navigateToBusinessesDetails<T>(
    BuildContext context,
    String businessesId,
  ) {
    debugPrint('🔍 Navegando para detalhes: $businessesId');
    return Navigator.pushNamed<T>(
      context,
      RouteConstants.businessesDetails,
      arguments: {'businessesId': businessesId},
    );
  }

  /// Navega para o profile
  static Future<T?> navigateToProfile<T>(BuildContext context) {
    return Navigator.pushReplacementNamed<T, dynamic>(
      context,
      RouteConstants.profile,
    );
  }

  /// Navega para home removendo histórico
  static Future<T?> navigateToHome<T>(BuildContext context) {
    return Navigator.pushNamedAndRemoveUntil<T>(
      context,
      RouteConstants.home,
      (route) => false,
    );
  }

  /// Navega para login removendo histórico
  static Future<T?> navigateToLogin<T>(BuildContext context) {
    return Navigator.pushNamedAndRemoveUntil<T>(
      context,
      RouteConstants.login,
      (route) => false,
    );
  }
}
