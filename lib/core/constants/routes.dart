import 'package:flutter/material.dart';

// Imports das telas que ainda estão no app principal
import '../../screens/splash/presentation/splash_screen.dart';
import '../../screens/onboarding/presentation/onboarding_screen.dart';
import '../../screens/location/presentation/location_permission_screen.dart';
import '../../screens/profile/presentation/profile_screen.dart';
import '../../screens/profile/presentation/edit_profile_screen.dart';
import '../../screens/profile/presentation/settings_screen.dart';
import '../../screens/premium/presentation/vivar_plus_screen.dart';
import '../../screens/challenges/presentation/challenges_screen.dart';
import '../../screens/loyalty_card/presentation/loyalty_card_screen.dart';
import '../../screens/notifications/presentation/notifications_screen.dart';
import '../../screens/merchant/presentation/merchant_register_screen.dart';

class AppRoutes {
  AppRoutes._();

  /// Retorna todas as rotas combinadas
  static Map<String, WidgetBuilder> get routes {
    return {
      // Rotas locais (ainda no app principal)
      RouteConstants.splash: (context) => SplashScreen(),
      RouteConstants.onboarding: (context) => OnboardingScreen(),
      RouteConstants.locationPermission: (context) =>
          LocationPermissionScreen(),
      RouteConstants.profile: (context) => ProfileScreen(),
      RouteConstants.editProfile: (context) => EditProfileScreen(),
      RouteConstants.settings: (context) => SettingsScreen(),
      RouteConstants.vivarPlus: (context) => VivarPlusScreen(),
      RouteConstants.challenges: (context) => ChallengesScreen(),
      RouteConstants.loyaltyCard: (context) => LoyaltyCardScreen(),
      RouteConstants.notifications: (context) => NotificationsScreen(),
      RouteConstants.merchantRegister: (context) => MerchantRegisterScreen(),

      // Rotas dos módulos (via registry)
      ...RouteRegistry.instance.allRoutes,
    };
  }

  /// Lida com rotas que precisam de argumentos
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    debugPrint('🔍 AppRoutes.onGenerateRoute: ${settings.name}');

    // Tenta resolver no registry (módulos)
    final route = RouteRegistry.instance.onGenerateRoute(settings);
    if (route != null) return route;

    // Se não encontrar, retorna null
    return null;
  }
}
