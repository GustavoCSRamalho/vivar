// // core/database/database_seeder.dart
// import 'package:flutter/foundation.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:vivar/models/business_model.dart';
// import '../../../../lib/core/repositories/place_repository.dart';
// import '../../../../lib/core/repositories/user_repository.dart';
// import '../../../../lib/models/place_model.dart';
// import '../../../../lib/models/user_model.dart';

// class DatabaseSeeder {
//   static const String _seedKey = 'database_seeded';
//   static const String _seedVersion = 'v3.0';

//   final PlaceRepository _placeRepo = PlaceRepository();
//   final UserRepository _userRepo = UserRepository();

//   /// Verifica se o banco já foi populado
//   Future<bool> isSeeded() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final seedVersion = prefs.getString(_seedKey);
//       return seedVersion == _seedVersion;
//     } catch (e) {
//       debugPrint('❌ Erro ao verificar seed: $e');
//       return false;
//     }
//   }

//   /// Marca o banco como populado
//   Future<void> _markAsSeeded() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString(_seedKey, _seedVersion);
//       debugPrint('✅ Banco marcado como populado (versão $_seedVersion)');
//     } catch (e) {
//       debugPrint('❌ Erro ao marcar seed: $e');
//     }
//   }

//   /// Popula o banco de dados com dados iniciais
//   Future<void> seed() async {
//     try {
//       // Verifica se já foi populado
//       // if (await isSeeded()) {
//       //   debugPrint('ℹ️ Banco de dados já foi populado anteriormente');
//       //   return;
//       // }

//       debugPrint('🌱 Iniciando população do banco de dados...');

//       // 1. Adicionar usuário de exemplo
//       await _seedUsers();

//       // 2. Adicionar lugares
//       await _seedBusinesses();

//       // Marca como populado
//       await _markAsSeeded();

//       debugPrint('✅ Banco de dados populado com sucesso!');
//     } catch (e) {
//       debugPrint('❌ Erro ao popular banco de dados: $e');
//       rethrow;
//     }
//   }

//   /// Popular usuários
//   Future<void> _seedUsers() async {
//     debugPrint('👤 Adicionando usuários...');

//     final user = UserModel(
//       id: 'user_demo',
//       name: 'Usuário Demo',
//       email: 'demo@vizinho.app',
//       location: 'São Paulo, SP',
//       planType: 'free',
//       points: 150,
//       businessesVisited: 5,
//       favoriteCount: 3,
//       badgesCount: 2,
//       streakDays: 3,
//       createdAt: DateTime.now(),
//       updatedAt: DateTime.now(),
//     );

//     await _userRepo.insert(user);
//     debugPrint('✅ Usuário demo criado: ${user.name}');
//   }

//   /// Popular lugares
//   Future<void> _seedBusinesses() async {
//     debugPrint('📍 Adicionando lugares...');

//     final businesses = [
//       BusinessModel(
//         id: 'mock_1',
//         name: 'Café Raiz',
//         category: 'Cafés',
//         description: 'Café artesanal com grãos especiais selecionados',
//         address: 'Rua das Flores, 123',
//         city: 'São Paulo',
//         state: 'SP',
//         latitude: -23.5505,
//         longitude: -46.6333,
//         phone: '(11) 98765-4321',
//         whatsapp: '(11) 98765-4321',
//         email: 'contato@caferaiz.com.br',
//         website: 'www.caferaiz.com.br',
//         rating: 4.8,
//         reviewsCount: 142,
//         priceRange: '\$\$',
//         isOpen: true,
//         openingHours: {
//           'seg-sex': '7:00-19:00',
//           'sab': '8:00-18:00',
//           'dom': '8:00-14:00',
//         },
//         amenities: ['Wi-Fi grátis', 'Pet friendly', 'Estacionamento'],
//         images: ['assets/images/cafe.png', 'assets/images/cafe2.png'],
//         discountText: '15% OFF',
//         discountPercentage: 15,
//         isPremiumOnly: false,
//         distance: 850.0,
//         createdAt: DateTime.now(),
//         updatedAt: DateTime.now(),
//         synced: true,
//       ),
//       BusinessModel(
//         id: 'mock_2',
//         name: 'Restaurante Bella Vita',
//         category: 'Restaurantes',
//         description: 'Culinária italiana autêntica com massas frescas',
//         address: 'Av. Paulista, 1000',
//         city: 'São Paulo',
//         state: 'SP',
//         latitude: -23.5515,
//         longitude: -46.6343,
//         phone: '(11) 3456-7890',
//         whatsapp: '(11) 98765-1234',
//         email: 'contato@bellavita.com.br',
//         website: 'www.bellavita.com.br',
//         rating: 4.6,
//         reviewsCount: 98,
//         priceRange: '\$\$\$',
//         isOpen: true,
//         openingHours: {'seg-dom': '11:00-23:00'},
//         amenities: ['Ar condicionado', 'Aceita cartão', 'Vinho', 'Romântico'],
//         images: ['assets/images/restaurant.png'],
//         discountText: '20% OFF',
//         discountPercentage: 20,
//         isPremiumOnly: true,
//         distance: 1200.0,
//         createdAt: DateTime.now(),
//         updatedAt: DateTime.now(),
//         synced: true,
//       ),
//       BusinessModel(
//         id: 'mock_3',
//         name: 'Bar do João',
//         category: 'Bares',
//         description: 'Chopp gelado e petiscos deliciosos',
//         address: 'Rua Augusta, 456',
//         city: 'São Paulo',
//         state: 'SP',
//         latitude: -23.5495,
//         longitude: -46.6323,
//         phone: '(11) 3333-4444',
//         whatsapp: '(11) 99999-8888',
//         rating: 4.5,
//         reviewsCount: 67,
//         priceRange: '\$\$',
//         isOpen: true,
//         openingHours: {'ter-dom': '17:00-01:00'},
//         amenities: ['Música ao vivo', 'Chopp', 'Petiscos'],
//         images: ['assets/images/bar.png'],
//         discountText: '10% OFF',
//         discountPercentage: 10,
//         isPremiumOnly: false,
//         distance: 650.0,
//         createdAt: DateTime.now(),
//         updatedAt: DateTime.now(),
//         synced: true,
//       ),
//       BusinessModel(
//         id: 'mock_4',
//         name: 'Padaria Aurora',
//         category: 'Lojas',
//         description: 'Pães quentinhos e bolos caseiros todos os dias',
//         address: 'Rua da Consolação, 789',
//         city: 'São Paulo',
//         state: 'SP',
//         latitude: -23.5525,
//         longitude: -46.6353,
//         phone: '(11) 2222-3333',
//         whatsapp: '(11) 98888-7777',
//         email: 'padaria@aurora.com.br',
//         rating: 4.7,
//         reviewsCount: 156,
//         priceRange: '\$',
//         isOpen: true,
//         openingHours: {'seg-sab': '6:00-20:00', 'dom': '6:00-14:00'},
//         amenities: ['Pães artesanais', 'Bolos', 'Café da manhã'],
//         images: ['assets/images/bakery.png'],
//         discountText: '5% OFF',
//         discountPercentage: 5,
//         isPremiumOnly: false,
//         distance: 300.0,
//         createdAt: DateTime.now(),
//         updatedAt: DateTime.now(),
//         synced: true,
//       ),
//       BusinessModel(
//         id: 'mock_5',
//         name: 'Sorveteria Gelato',
//         category: 'Lojas',
//         description: 'Sorvetes artesanais com mais de 30 sabores',
//         address: 'Rua Oscar Freire, 321',
//         city: 'São Paulo',
//         state: 'SP',
//         latitude: -23.5485,
//         longitude: -46.6313,
//         phone: '(11) 4444-5555',
//         whatsapp: '(11) 97777-6666',
//         website: 'www.gelato.com.br',
//         rating: 4.9,
//         reviewsCount: 203,
//         priceRange: '\$\$',
//         isOpen: true,
//         openingHours: {'seg-dom': '10:00-22:00'},
//         amenities: ['Artesanal', 'Natural', 'Vegano', 'Sem lactose'],
//         images: ['assets/images/ice.png'],
//         discountText: '2º sabor grátis',
//         discountPercentage: 0,
//         isPremiumOnly: false,
//         distance: 1500.0,
//         createdAt: DateTime.now(),
//         updatedAt: DateTime.now(),
//         synced: true,
//       ),
//       BusinessModel(
//         id: 'mock_6',
//         name: 'Bistrô Central',
//         category: 'Restaurantes',
//         description: 'Pratos contemporâneos e ambiente sofisticado',
//         address: 'Rua Haddock Lobo, 555',
//         city: 'São Paulo',
//         state: 'SP',
//         latitude: -23.5535,
//         longitude: -46.6363,
//         phone: '(11) 5555-6666',
//         email: 'bistro@central.com.br',
//         website: 'www.bistrocentral.com.br',
//         rating: 4.4,
//         reviewsCount: 89,
//         priceRange: '\$\$\$',
//         isOpen: false,
//         openingHours: {'ter-sab': '12:00-15:00, 19:00-23:00'},
//         amenities: ['Ar condicionado', 'Estacionamento', 'Aceita cartão'],
//         images: ['assets/images/bistro.png'],
//         discountPercentage: 0,
//         isPremiumOnly: false,
//         distance: 2100.0,
//         createdAt: DateTime.now(),
//         updatedAt: DateTime.now(),
//         synced: true,
//       ),
//       BusinessModel(
//         id: 'mock_7',
//         name: 'Lanchonete do Bairro',
//         category: 'Restaurantes',
//         description: 'Lanches artesanais e sucos naturais',
//         address: 'Rua Frei Caneca, 222',
//         city: 'São Paulo',
//         state: 'SP',
//         latitude: -23.5545,
//         longitude: -46.6373,
//         phone: '(11) 6666-7777',
//         whatsapp: '(11) 96666-5555',
//         rating: 4.3,
//         reviewsCount: 45,
//         priceRange: '\$',
//         isOpen: true,
//         openingHours: {'seg-sex': '10:00-22:00', 'sab-dom': '10:00-20:00'},
//         amenities: ['Delivery', 'Aceita cartão', 'Sucos naturais'],
//         images: ['assets/images/lanche.png'],
//         discountText: '10% OFF',
//         discountPercentage: 10,
//         isPremiumOnly: false,
//         distance: 450.0,
//         createdAt: DateTime.now(),
//         updatedAt: DateTime.now(),
//         synced: true,
//       ),
//       BusinessModel(
//         id: 'mock_8',
//         name: 'Café Literário',
//         category: 'Cafés',
//         description: 'Café com livraria e espaço para leitura',
//         address: 'Rua dos Pinheiros, 888',
//         city: 'São Paulo',
//         state: 'SP',
//         latitude: -23.5555,
//         longitude: -46.6383,
//         phone: '(11) 7777-8888',
//         whatsapp: '(11) 95555-4444',
//         email: 'cafe@literario.com.br',
//         website: 'www.cafeliterario.com.br',
//         rating: 4.6,
//         reviewsCount: 112,
//         priceRange: '\$\$',
//         isOpen: true,
//         openingHours: {'seg-dom': '8:00-22:00'},
//         amenities: ['Wi-Fi grátis', 'Livraria', 'Ambiente silencioso'],
//         images: ['assets/images/cafe2.png'],
//         discountText: '12% OFF',
//         discountPercentage: 12,
//         isPremiumOnly: true,
//         distance: 950.0,
//         createdAt: DateTime.now(),
//         updatedAt: DateTime.now(),
//         synced: true,
//       ),
//     ];

//     // Inserir cada lugar
//     for (final place in businesses) {
//       await _placeRepo.insert(place);
//       debugPrint('✅ Lugar adicionado: ${place.name}');
//     }

//     debugPrint('✅ ${businesses.length} lugares adicionados com sucesso!');
//   }

//   /// Limpa todos os dados e repopula (útil para testes)
//   Future<void> reseed() async {
//     try {
//       debugPrint('🔄 Limpando banco de dados...');

//       final prefs = await SharedPreferences.getInstance();
//       await prefs.remove(_seedKey);

//       // Limpar tabelas (implementar nos repositories se necessário)
//       // await _placeRepo.deleteAll();
//       // await _userRepo.deleteAll();

//       debugPrint('✅ Banco limpo, repopulando...');
//       await seed();
//     } catch (e) {
//       debugPrint('❌ Erro ao limpar e repopular: $e');
//       rethrow;
//     }
//   }
// }
