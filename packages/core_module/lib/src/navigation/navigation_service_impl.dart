import 'package:flutter/material.dart';
import 'navigation_service.dart';

class NavigationServiceImpl implements NavigationService {
  final GlobalKey<NavigatorState> navigatorKey;

  NavigationServiceImpl(this.navigatorKey);

  BuildContext? get _context => navigatorKey.currentContext;

  @override
  Future<T?> navigateTo<T>(String routeName, {Object? arguments}) {
    if (_context == null) {
      debugPrint('❌ Navigation context não disponível');
      return Future.value(null);
    }
    return Navigator.pushNamed<T>(
      _context!,
      routeName,
      arguments: arguments,
    );
  }

  @override
  Future<T?> navigateAndReplace<T>(String routeName, {Object? arguments}) {
    if (_context == null) return Future.value(null);
    return Navigator.pushReplacementNamed<T, dynamic>(
      _context!,
      routeName,
      arguments: arguments,
    );
  }

  @override
  Future<T?> navigateAndRemoveUntil<T>(
    String routeName, {
    Object? arguments,
    bool Function(Route<dynamic>)? predicate,
  }) {
    if (_context == null) return Future.value(null);
    return Navigator.pushNamedAndRemoveUntil<T>(
      _context!,
      routeName,
      predicate ?? (route) => false,
      arguments: arguments,
    );
  }

  @override
  void goBack<T>([T? result]) {
    if (_context == null) return;
    Navigator.pop<T>(_context!, result);
  }

  @override
  bool canGoBack() {
    if (_context == null) return false;
    return Navigator.canPop(_context!);
  }
}
