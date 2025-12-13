import 'package:flutter/material.dart';

/// Interface de navegação que os módulos podem usar
/// sem conhecer a implementação
abstract class NavigationService {
  /// Navega para uma rota
  Future<T?> navigateTo<T>(String routeName, {Object? arguments});

  /// Navega substituindo a rota atual
  Future<T?> navigateAndReplace<T>(String routeName, {Object? arguments});

  /// Navega removendo todas as rotas anteriores
  Future<T?> navigateAndRemoveUntil<T>(
    String routeName, {
    Object? arguments,
    bool Function(Route<dynamic>)? predicate,
  });

  /// Volta para a tela anterior
  void goBack<T>([T? result]);

  /// Verifica se pode voltar
  bool canGoBack();
}
