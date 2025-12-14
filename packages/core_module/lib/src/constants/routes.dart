/// Constantes de rotas compartilhadas entre módulos
/// Este arquivo NÃO tem dependências de nenhum módulo
class RouteConstants {
  RouteConstants._();

  // Core/App
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String locationPermission = '/location-permission';

  // Auth
  static const String login = '/login';
  static const String register = '/register';

  // Home
  static const String home = '/home';
  static const String discover = '/discover';
  static const String swipe = '/swipe';
  static const String map = '/map';

  // Profile
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String settings = '/settings';

  // Businesses
  static const String businessesDetails = '/businesses-details';

  // Premium/Features
  static const String vivarPlus = '/vivar-plus';
  // static const String challenges = '/challenges';
  // static const String loyaltyCard = '/loyalty-card';
  // static const String notifications = '/notifications';
  static const String merchantRegister = '/merchant-register';
}
