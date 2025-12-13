import 'package:flutter/material.dart';

abstract class RouteProvider {
  /// Nome identificador do provider (ex: 'auth', 'home')
  String get namespace;

  /// Constantes de rotas
  Map<String, String> get routeNames;

  /// Mapa de rotas simples
  Map<String, WidgetBuilder> get routes;

  /// Rotas com argumentos (opcional)
  Route<dynamic>? onGenerateRoute(RouteSettings settings) => null;
}
