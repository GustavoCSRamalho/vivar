// // core/services/sync_service.dart
// import 'package:flutter/foundation.dart';
// import '../repositories/user_repository.dart';
// import '../repositories/place_repository.dart';
// import '../repositories/checkin_repository.dart';
// import '../repositories/favorite_repository.dart';
// import '../repositories/badge_repository.dart';
// import '../repositories/challenge_repository.dart';
// import '../repositories/notification_repository.dart';
// import '../repositories/review_repository.dart';

// class SyncService {
//   static final SyncService _instance = SyncService._internal();
//   factory SyncService() => _instance;
//   SyncService._internal();

//   final UserRepository _userRepo = UserRepository();
//   final PlaceRepository _placeRepo = PlaceRepository();
//   final CheckinRepository _checkinRepo = CheckinRepository();
//   final FavoriteRepository _favoriteRepo = FavoriteRepository();
//   final BadgeRepository _badgeRepo = BadgeRepository();
//   final ChallengeRepository _challengeRepo = ChallengeRepository();
//   final NotificationRepository _notificationRepo = NotificationRepository();
//   final ReviewRepository _reviewRepo = ReviewRepository();

//   bool _isSyncing = false;

//   // Sincronizar tudo
//   Future<bool> syncAll(String userId) async {
//     if (_isSyncing) return false;

//     _isSyncing = true;

//     try {
//       await Future.wait([
//         syncUsers(),
//         syncCheckins(userId),
//         syncFavorites(userId),
//         syncBadges(userId),
//         syncChallenges(userId),
//         syncReviews(userId),
//       ]);

//       debugPrint('✅ Sincronização completa realizada com sucesso');
//       return true;
//     } catch (e) {
//       debugPrint('❌ Erro na sincronização: $e');
//       return false;
//     } finally {
//       _isSyncing = false;
//     }
//   }

//   // Sincronizar usuários
//   Future<void> syncUsers() async {
//     try {
//       final unsynced = await _userRepo.getUnsyncedItems();

//       for (var user in unsynced) {
//         // TODO: Enviar para Supabase
//         // await supabase.from('users').upsert(user.toJson());

//         // Marcar como sincronizado
//         await _userRepo.markAsSynced(user.id);
//       }

//       debugPrint('✅ ${unsynced.length} usuários sincronizados');
//     } catch (e) {
//       debugPrint('❌ Erro ao sincronizar usuários: $e');
//       rethrow;
//     }
//   }

//   // Sincronizar check-ins
//   Future<void> syncCheckins(String userId) async {
//     try {
//       final unsynced = await _checkinRepo.getUnsyncedItems();
//       final userCheckins = unsynced.where((c) => c.userId == userId).toList();

//       for (var checkin in userCheckins) {
//         // TODO: Enviar para Supabase
//         // await supabase.from('checkins').insert(checkin.toJson());

//         await _checkinRepo.markAsSynced(checkin.id);
//       }

//       debugPrint('✅ ${userCheckins.length} check-ins sincronizados');
//     } catch (e) {
//       debugPrint('❌ Erro ao sincronizar check-ins: $e');
//       rethrow;
//     }
//   }

//   // Sincronizar favoritos
//   Future<void> syncFavorites(String userId) async {
//     try {
//       final unsynced = await _favoriteRepo.getUnsyncedItems();
//       final userFavorites = unsynced.where((f) => f.userId == userId).toList();

//       for (var favorite in userFavorites) {
//         // TODO: Enviar para Supabase
//         // await supabase.from('favorites').insert(favorite.toMap());

//         await _favoriteRepo.markAsSynced(favorite.id);
//       }

//       debugPrint('✅ ${userFavorites.length} favoritos sincronizados');
//     } catch (e) {
//       debugPrint('❌ Erro ao sincronizar favoritos: $e');
//       rethrow;
//     }
//   }

//   // Sincronizar badges
//   Future<void> syncBadges(String userId) async {
//     try {
//       final unsynced = await _badgeRepo.getUnsyncedItems();
//       final userBadges = unsynced.where((b) => b.userId == userId).toList();

//       for (var badge in userBadges) {
//         // TODO: Enviar para Supabase
//         // await supabase.from('badges').insert(badge.toMap());

//         await _badgeRepo.markAsSynced(badge.id);
//       }

//       debugPrint('✅ ${userBadges.length} badges sincronizados');
//     } catch (e) {
//       debugPrint('❌ Erro ao sincronizar badges: $e');
//       rethrow;
//     }
//   }

//   // Sincronizar desafios
//   Future<void> syncChallenges(String userId) async {
//     try {
//       final unsynced = await _challengeRepo.getUnsyncedItems();
//       final userChallenges = unsynced.where((c) => c.userId == userId).toList();

//       for (var challenge in userChallenges) {
//         // TODO: Enviar para Supabase
//         // await supabase.from('challenges').upsert(challenge.toMap());

//         await _challengeRepo.markAsSynced(challenge.id);
//       }

//       debugPrint('✅ ${userChallenges.length} desafios sincronizados');
//     } catch (e) {
//       debugPrint('❌ Erro ao sincronizar desafios: $e');
//       rethrow;
//     }
//   }

//   // Sincronizar reviews
//   Future<void> syncReviews(String userId) async {
//     try {
//       final unsynced = await _reviewRepo.getUnsyncedItems();
//       final userReviews = unsynced.where((r) => r.userId == userId).toList();

//       for (var review in userReviews) {
//         // TODO: Enviar para Supabase
//         // await supabase.from('reviews').insert(review.toMap());

//         await _reviewRepo.markAsSynced(review.id);
//       }

//       debugPrint('✅ ${userReviews.length} reviews sincronizadas');
//     } catch (e) {
//       debugPrint('❌ Erro ao sincronizar reviews: $e');
//       rethrow;
//     }
//   }

//   // Baixar dados do servidor (quando migrar para Supabase)
//   Future<void> downloadFromServer(String userId) async {
//     try {
//       // TODO: Implementar quando migrar para Supabase
//       /*
//       // Baixar lugares
//       final businessesData = await supabase.from('businesses').select();
//       for (var data in businessesData) {
//         final place = PlaceModel.fromJson(data);
//         await _placeRepo.insert(place);
//       }
      
//       // Baixar dados do usuário
//       final userData = await supabase
//           .from('users')
//           .select()
//           .eq('id', userId)
//           .single();
//       final user = UserModel.fromJson(userData);
//       await _userRepo.insert(user);
      
//       // Baixar check-ins
//       final checkinsData = await supabase
//           .from('checkins')
//           .select()
//           .eq('user_id', userId);
//       for (var data in checkinsData) {
//         final checkin = CheckinModel.fromJson(data);
//         await _checkinRepo.insert(checkin);
//       }
      
//       // E assim por diante...
//       */

//       debugPrint('✅ Dados baixados do servidor');
//     } catch (e) {
//       debugPrint('❌ Erro ao baixar dados: $e');
//       rethrow;
//     }
//   }

//   // Verificar se há dados não sincronizados
//   Future<bool> hasUnsyncedData() async {
//     try {
//       final counts = await Future.wait([
//         _userRepo.getUnsyncedItems().then((items) => items.length),
//         _checkinRepo.getUnsyncedItems().then((items) => items.length),
//         _favoriteRepo.getUnsyncedItems().then((items) => items.length),
//         _badgeRepo.getUnsyncedItems().then((items) => items.length),
//         _challengeRepo.getUnsyncedItems().then((items) => items.length),
//         _reviewRepo.getUnsyncedItems().then((items) => items.length),
//       ]);

//       final totalUnsynced = counts.reduce((a, b) => a + b);
//       return totalUnsynced > 0;
//     } catch (e) {
//       debugPrint('❌ Erro ao verificar dados não sincronizados: $e');
//       return false;
//     }
//   }

//   // Limpar cache local (após confirmação de sincronização)
//   Future<void> clearLocalCache() async {
//     try {
//       // Aqui você pode implementar lógica para limpar dados antigos
//       // mantendo apenas os essenciais
//       debugPrint('✅ Cache local limpo');
//     } catch (e) {
//       debugPrint('❌ Erro ao limpar cache: $e');
//     }
//   }
// }
