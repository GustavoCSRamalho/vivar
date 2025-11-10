// core/constants/routes.dart
import 'package:flutter/material.dart';
import '../../screens/splash/splash_screen.dart';
import '../../screens/onboarding/onboarding_screen.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/location/location_permission_screen.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/discover/discover_screen.dart';
import '../../screens/swipe/swipe_screen.dart';
import '../../screens/map/map_screen.dart';
import '../../screens/place_details/place_details_screen.dart';
import '../../screens/profile/profile_screen.dart';
import '../../screens/profile/edit_profile_screen.dart';
import '../../screens/profile/settings_screen.dart';
import '../../screens/premium/vivar_plus_screen.dart';
import '../../screens/challenges/challenges_screen.dart';
import '../../screens/loyalty_card/loyalty_card_screen.dart';
import '../../screens/notifications/notifications_screen.dart';
import '../../screens/merchant/merchant_register_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String locationPermission = '/location-permission';
  static const String home = '/home';
  static const String discover = '/discover';
  static const String swipe = '/swipe';
  static const String map = '/map';
  static const String placeDetails = '/place-details';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String settings = '/settings';
  static const String vivarPlus = '/vivar-plus';
  static const String challenges = '/challenges';
  static const String loyaltyCard = '/loyalty-card';
  static const String notifications = '/notifications';
  static const String merchantRegister = '/merchant-register';

  // Rotas que não precisam de argumentos
  static Map<String, WidgetBuilder> get routes {
    return {
      splash: (context) => SplashScreen(),
      onboarding: (context) => OnboardingScreen(),
      login: (context) => LoginScreen(),
      locationPermission: (context) => LocationPermissionScreen(),
      home: (context) => HomeScreen(),
      discover: (context) => DiscoverScreen(),
      swipe: (context) => SwipeScreen(),
      map: (context) => MapScreen(),
      profile: (context) => ProfileScreen(),
      editProfile: (context) => EditProfileScreen(),
      settings: (context) => SettingsScreen(),
      vivarPlus: (context) => VivarPlusScreen(),
      challenges: (context) => ChallengesScreen(),
      loyaltyCard: (context) => LoyaltyCardScreen(),
      notifications: (context) => NotificationsScreen(),
      merchantRegister: (context) => MerchantRegisterScreen(),
    };
  }

  // Método para lidar com rotas com argumentos
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    debugPrint('🔍 Navegando para detalhes do lugar: $settings');
    debugPrint('🔍 Navegando para detalhes do lugar name: ${settings.name}');

    switch (settings.name) {
      case placeDetails:
        // Extrai os argumentos

        final args = settings.arguments as Map<String, dynamic>?;
        final placeId = args?['placeId'] as String?;
        debugPrint('🏪 Abrindo detalhes do lugar: $placeId');

        if (placeId == null) {
          debugPrint('❌ ID do lugar não fornecido');

          // Se não tiver placeId, retorna para home
          return MaterialPageRoute(builder: (context) => HomeScreen());
        }

        return MaterialPageRoute(
          builder: (context) => PlaceDetailsScreen(placeId: placeId),
        );

      default:
        return null;
    }
  }

  // Método helper para navegação com argumentos
  static Future<T?> navigateToPlaceDetails<T>(
    BuildContext context,
    String placeId,
  ) {
    debugPrint('🔍 Navegando para detalhes do lugar: $placeId');
    return Navigator.pushNamed<T>(
      context,
      placeDetails,
      arguments: {'placeId': placeId},
    );
  }
}
