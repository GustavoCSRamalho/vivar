// main.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivar/core/database/database_seeder.dart';
import 'package:vivar/factory/discover_provider_factory.dart';
import 'package:vivar/factory/edit_profile_provider_factory.dart';
import 'package:vivar/factory/forgot_password_provider_factory.dart';
import 'package:vivar/factory/home_provider_factory.dart';
import 'package:vivar/factory/location_permission_provider_factory.dart';
import 'package:vivar/factory/login_provider_factory.dart';
import 'package:vivar/factory/map_provider_factory.dart';
import 'package:vivar/factory/merchant_register_provider_factory.dart';
import 'package:vivar/factory/onboarding_provider_factory.dart';
import 'package:vivar/factory/place_details_provider_factory.dart';
import 'package:vivar/factory/profile_provider_factory.dart';
import 'package:vivar/factory/register_provider_factory.dart';
import 'package:vivar/factory/settings_provider_factory.dart';
import 'package:vivar/factory/swipe_provider_factory.dart';
import 'package:vivar/screens/home/data/models/place_model.dart';
import 'package:vivar/screens/swipe/presentation/providers/swipe_provider.dart';
import 'app.dart';
import 'providers/auth_provider.dart';
import 'providers/places_provider.dart';
import 'providers/user_provider.dart';
import 'providers/favorites_provider.dart';
import 'providers/checkins_provider.dart';
import 'providers/badges_provider.dart';
import 'providers/challenges_provider.dart';
import 'providers/notifications_provider.dart';
import 'core/database/database_helper.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar banco de dados
  await DatabaseHelper().deleteDatabase();
  await DatabaseHelper().database;
  await DatabaseHelper().clearAllData();

  // Popular banco de dados com mocks (apenas na primeira vez)
  final seeder = DatabaseSeeder();
  await seeder.seed();

  await _testDatabaseDirectly();

  final homeProvider = HomeProviderFactory.create();
  final profileProvider = ProfileProviderFactory.create();
  final mapsProvider = MapProviderFactory.create();
  final placeDetailsProviderFactory = PlaceDetailsProviderFactory.create();
  final swipeProvider = SwipeProviderFactory.create();
  final discoverProvider = DiscoverProviderFactory.create();
  final onboardingProvider = OnboardingProviderFactory.create();
  final merchantRegisterProviderFactory =
      MerchantRegisterProviderFactory.create();
  final locationPermissionProviderFactory =
      LocationPermissionProviderFactory.create();
  final loginProviderFactory = LoginProviderFactory.create();
  final registerProviderFactory = RegisterProviderFactory.create();
  final forgotPasswordProviderFactory = ForgotPasswordProviderFactory.create();
  final editProfileProviderFactory = EditProfileProviderFactory.create();
  final settingsProviderFactory = SettingsProviderFactory.create();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => homeProvider),
        ChangeNotifierProvider(create: (_) => profileProvider),
        ChangeNotifierProvider(create: (_) => mapsProvider),
        ChangeNotifierProvider(create: (_) => placeDetailsProviderFactory),
        ChangeNotifierProvider(create: (_) => swipeProvider),
        ChangeNotifierProvider(create: (_) => discoverProvider),
        ChangeNotifierProvider(create: (_) => onboardingProvider),
        ChangeNotifierProvider(create: (_) => merchantRegisterProviderFactory),
        ChangeNotifierProvider(
          create: (_) => locationPermissionProviderFactory,
        ),
        ChangeNotifierProvider(create: (_) => loginProviderFactory),
        ChangeNotifierProvider(create: (_) => registerProviderFactory),
        ChangeNotifierProvider(create: (_) => forgotPasswordProviderFactory),
        ChangeNotifierProvider(create: (_) => editProfileProviderFactory),
        ChangeNotifierProvider(create: (_) => settingsProviderFactory),
        // ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => PlacesProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => CheckinsProvider()),
        ChangeNotifierProvider(create: (_) => BadgesProvider()),
        ChangeNotifierProvider(create: (_) => ChallengesProvider()),
        ChangeNotifierProvider(create: (_) => NotificationsProvider()),
      ],
      child: VivarApp(),
    ),
  );
}

Future<void> _testDatabaseDirectly() async {
  debugPrint('🧪 TESTE DIRETO NO BANCO');

  try {
    final db = await DatabaseHelper().database;

    // 1. Verificar se a tabela existe
    final tables = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name='places'",
    );
    debugPrint('📋 Tabela places existe? ${tables.isNotEmpty}');

    if (tables.isEmpty) {
      debugPrint('❌ PROBLEMA: Tabela places não existe!');
      return;
    }

    // 2. Contar registros
    final count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM places'),
    );
    debugPrint('📊 Total de registros: $count');

    if (count == 0) {
      debugPrint('⚠️ BANCO VAZIO! Vamos inserir um teste...');

      // 3. Inserir um registro de teste MANUALMENTE
      await db.insert('places', {
        'id': 'test_manual_${DateTime.now().millisecondsSinceEpoch}',
        'name': 'Teste Manual',
        'category': 'Cafés',
        'address': 'Rua Teste, 123',
        'city': 'São Paulo',
        'state': 'SP',
        'latitude': -23.5505,
        'longitude': -46.6333,
        'rating': 5.0,
        'reviews_count': 1,
        'is_open': 1,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
        'synced': 0,
      });

      debugPrint('✅ Registro de teste inserido!');

      // 4. Verificar novamente
      final newCount = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM places'),
      );
      debugPrint('📊 Novo total: $newCount');
    }

    // 5. Buscar e mostrar os primeiros 3
    final maps = await db.query('places', limit: 3);
    debugPrint('📋 Primeiros registros:');
    for (var map in maps) {
      debugPrint('   - ${map['name']} (${map['id']})');
    }

    // 6. Testar PlaceModel.fromMap()
    if (maps.isNotEmpty) {
      try {
        final place = PlaceModel.fromMap(maps.first);
        debugPrint('✅ PlaceModel.fromMap() funcionou: ${place.name}');
      } catch (e, stack) {
        debugPrint('❌ ERRO no PlaceModel.fromMap(): $e');
        debugPrint('Stack: $stack');
        debugPrint('Map que causou erro: ${maps.first}');
      }
    }
  } catch (e, stack) {
    debugPrint('❌ ERRO NO TESTE: $e');
    debugPrint('Stack: $stack');
  }
}
