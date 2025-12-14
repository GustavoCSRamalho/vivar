import 'package:authentication_module/authentication_module.dart';
import 'package:core_module/core_module.dart';
import 'package:discover_module/discover_module.dart';
import 'package:flutter/material.dart';
import 'package:home_module/home_module.dart';
import 'package:location_module/location_module.dart';
import 'package:map_module/map_module.dart';
import 'package:merchant_module/merchant_module.dart';
import 'package:onboarding_module/onboarding_module.dart';
import 'package:place_details_module/place_details_module.dart';
import 'package:premium_module/premium_module.dart';
import 'package:profile_module/profile_module.dart';
import 'package:splash_module/splash_module.dart';
import 'package:swipe_module/swipe_module.dart';

// Imports das telas que ainda estão no app principal
import '../../screens/challenges/presentation/challenges_screen.dart';
import '../../screens/loyalty_card/presentation/loyalty_card_screen.dart';
import '../../screens/notifications/presentation/notifications_screen.dart';

class AppRoutes {
  AppRoutes._();

  /// Retorna todas as rotas combinadas
  static Map<String, WidgetBuilder> get routes {
    return {
      // Rotas locais (ainda no app principal)
      RouteConstants.splash: (context) => SplashScreen(),
      RouteConstants.login: (context) => LoginScreen(),
      RouteConstants.register: (context) => RegisterScreen(),
      RouteConstants.onboarding: (context) => OnboardingScreen(),
      RouteConstants.locationPermission: (context) =>
          LocationPermissionScreen(),
      RouteConstants.profile: (context) => ProfileScreen(),
      RouteConstants.editProfile: (context) => EditProfileScreen(),
      RouteConstants.settings: (context) => SettingsScreen(),
      RouteConstants.vivarPlus: (context) => VivarPlusScreen(),
      RouteConstants.home: (context) => HomeScreen(),
      RouteConstants.discover: (context) => DiscoverScreen(),
      RouteConstants.swipe: (context) => SwipeScreen(),
      RouteConstants.map: (context) => MapScreen(),
      // RouteConstants.challenges: (context) => ChallengesScreen(),
      // RouteConstants.loyaltyCard: (context) => LoyaltyCardScreen(),
      // RouteConstants.notifications: (context) => NotificationsScreen(),
      RouteConstants.merchantRegister: (context) => MerchantRegisterScreen(),

      // Rotas dos módulos (via registry)
      // ...RouteRegistry.instance.allRoutes,
    };
  }

  /// Lida com rotas que precisam de argumentos
  /// Lida com rotas que precisam de argumentos
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    debugPrint('🔍 AppRoutes.onGenerateRoute: ${settings.name}');
    debugPrint('📦 Argumentos: ${settings.arguments}');

    switch (settings.name) {
      // ========================================================================
      // ROTAS COM ARGUMENTOS
      // ========================================================================

      case RouteConstants.businessesDetails:
        final args = settings.arguments as Map<String, dynamic>?;
        final businessesId = args?['businessesId'] as String?;

        debugPrint('🏪 Abrindo detalhes do negócio: $businessesId');

        if (businessesId == null) {
          debugPrint('❌ ID do negócio não fornecido');
          // Retorna para home se não tiver ID
          return MaterialPageRoute(builder: (context) => HomeScreen());
        }

        return MaterialPageRoute(
          builder: (context) =>
              BusinessesDetailsScreen(businessesId: businessesId),
        );

      // Adicione outras rotas com argumentos aqui
      // case RouteConstants.outroDetalhe:
      //   final args = settings.arguments as Map<String, dynamic>?;
      //   final id = args?['id'] as String?;
      //
      //   if (id == null) return null;
      //
      //   return MaterialPageRoute(
      //     builder: (context) => OutroDetalheScreen(id: id),
      //   );

      default:
        debugPrint('❌ Rota não encontrada: ${settings.name}');
        return null;
    }
  }
}
