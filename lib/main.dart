// main.dart
import 'package:authentication_module/authentication_module.dart';
import 'package:core_module/core_module.dart';
import 'package:discover_module/discover_module.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:splash_module/splash_module.dart';
import 'package:home_module/home_module.dart';
import 'package:swipe_module/swipe_module.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vivar/factory/challenges_provider_factory.dart';
import 'package:vivar/factory/edit_profile_provider_factory.dart';
import '../packages/location_module/lib/src/factory/location_permission_provider_factory.dart';
import 'package:vivar/factory/loyalty_card_provider_factory.dart';
import 'package:vivar/factory/merchant_register_provider_factory.dart';
import 'package:vivar/factory/notifications_provider_factory.dart';
import '../packages/onboarding_module/lib/src/factory/onboarding_provider_factory.dart';
import '../packages/place_details_module/lib/src/factory/place_details_provider_factory.dart';
import '../packages/profile_module/lib/src/factory/profile_provider_factory.dart';
import 'package:vivar/factory/settings_provider_factory.dart';
import 'package:vivar/factory/subscription_provider_factory.dart';
import 'package:vivar/firebase_options.dart';
import 'package:vivar/models/place_model.dart';
import 'app.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await Supabase.initialize(
    url: 'https://csgqqnbqcmlgodrxysuj.supabase.co', // https://xxx.supabase.co
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNzZ3FxbmJxY21sZ29kcnh5c3VqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM5MzAyMzUsImV4cCI6MjA3OTUwNjIzNX0.Fwe3JK2kmzxBgbA3Jn6gYw-wqFuiSXwkIbr5UTmWruA',
  );
  // Inicializar banco de dados
  await DatabaseHelper().deleteDatabase();
  await DatabaseHelper().database;
  await DatabaseHelper().clearAllData();

  // Popular banco de dados com mocks (apenas na primeira vez)
  // final seeder = DatabaseSeeder();
  // await seeder.seed();

  // await _testDatabaseDirectly();

  final homeProvider = HomeProviderFactory.create();
  final profileProvider = ProfileProviderFactory.create();
  final placeDetailsProviderFactory = PlaceDetailsProviderFactory.create();
  final swipeProvider = SwipeProviderFactory.create();
  final discoverProvider = DiscoverProviderFactory.create();
  final onboardingProvider = OnboardingProviderFactory.create();
  final merchantRegisterProvider = MerchantRegisterProviderFactory.create();
  final locationPermissionProvider = LocationPermissionProviderFactory.create();
  final loginProvider = LoginProviderFactory.create();
  final registerProvider = RegisterProviderFactory.create();
  final forgotPasswordProvider = ForgotPasswordProviderFactory.create();
  final editProfileProvider = EditProfileProviderFactory.create();
  final settingsProvider = SettingsProviderFactory.create();
  final splashProvider = SplashProviderFactory.create();
  final subscriptionProvider = SubscriptionProviderFactory.create();
  final loyaltyCardProvider = LoyaltyCardProviderFactory.create();
  final notificationProvider = NotificationsProviderFactory.create();
  final challengesProvider = ChallengesProviderFactory.create();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => splashProvider),
        ChangeNotifierProvider(create: (_) => subscriptionProvider),
        ChangeNotifierProvider(create: (_) => homeProvider),
        ChangeNotifierProvider(create: (_) => profileProvider),
        ChangeNotifierProvider(create: (_) => placeDetailsProviderFactory),
        ChangeNotifierProvider(create: (_) => swipeProvider),
        ChangeNotifierProvider(create: (_) => discoverProvider),
        ChangeNotifierProvider(create: (_) => onboardingProvider),
        ChangeNotifierProvider(create: (_) => merchantRegisterProvider),
        ChangeNotifierProvider(create: (_) => locationPermissionProvider),
        ChangeNotifierProvider(create: (_) => loginProvider),
        ChangeNotifierProvider(create: (_) => registerProvider),
        ChangeNotifierProvider(create: (_) => forgotPasswordProvider),
        ChangeNotifierProvider(create: (_) => editProfileProvider),
        ChangeNotifierProvider(create: (_) => settingsProvider),
        ChangeNotifierProvider(create: (_) => loyaltyCardProvider),
        ChangeNotifierProvider(create: (_) => notificationProvider),
        ChangeNotifierProvider(create: (_) => challengesProvider),
      ],
      child: VivarApp(),
    ),
  );
}

// Future<void> _testDatabaseDirectly() async {
//   debugPrint('🧪 TESTE DIRETO NO BANCO');

//   try {
//     final db = await DatabaseHelper().database;

//     // 1. Verificar se a tabela existe
//     final tables = await db.rawQuery(
//       "SELECT name FROM sqlite_master WHERE type='table' AND name='businesses'",
//     );
//     debugPrint('📋 Tabela businesses existe? ${tables.isNotEmpty}');

//     if (tables.isEmpty) {
//       debugPrint('❌ PROBLEMA: Tabela businesses não existe!');
//       return;
//     }

//     // 2. Contar registros
//     final count = Sqflite.firstIntValue(
//       await db.rawQuery('SELECT COUNT(*) FROM businesses'),
//     );
//     debugPrint('📊 Total de registros: $count');

//     if (count == 0) {
//       debugPrint('⚠️ BANCO VAZIO! Vamos inserir um teste...');

//       // 3. Inserir um registro de teste MANUALMENTE
//       await db.insert('businesses', {
//         'id': 'test_manual_${DateTime.now().millisecondsSinceEpoch}',
//         'name': 'Teste Manual',
//         'category': 'Cafés',
//         'address': 'Rua Teste, 123',
//         'city': 'São Paulo',
//         'state': 'SP',
//         'latitude': -23.5505,
//         'longitude': -46.6333,
//         'rating': 5.0,
//         'reviews_count': 1,
//         'is_open': 1,
//         'created_at': DateTime.now().toIso8601String(),
//         'updated_at': DateTime.now().toIso8601String(),
//         'synced': 0,
//       });

//       debugPrint('✅ Registro de teste inserido!');

//       // 4. Verificar novamente
//       final newCount = Sqflite.firstIntValue(
//         await db.rawQuery('SELECT COUNT(*) FROM businesses'),
//       );
//       debugPrint('📊 Novo total: $newCount');
//     }

//     // 5. Buscar e mostrar os primeiros 3
//     final maps = await db.query('businesses', limit: 3);
//     debugPrint('📋 Primeiros registros:');
//     for (var map in maps) {
//       debugPrint('   - ${map['name']} (${map['id']})');
//     }

//     // 6. Testar PlaceModel.fromMap()
//     if (maps.isNotEmpty) {
//       try {
//         final place = BusinessModel.fromMap(maps.first);
//         debugPrint('✅ PlaceModel.fromMap() funcionou: ${place.name}');
//       } catch (e, stack) {
//         debugPrint('❌ ERRO no PlaceModel.fromMap(): $e');
//         debugPrint('Stack: $stack');
//         debugPrint('Map que causou erro: ${maps.first}');
//       }
//     }
//   } catch (e, stack) {
//     debugPrint('❌ ERRO NO TESTE: $e');
//     debugPrint('Stack: $stack');
//   }
// }
