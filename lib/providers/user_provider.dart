// // providers/user_provider.dart
// import 'package:flutter/foundation.dart';
// import 'package:vivar/models/user_model.dart';
// import '../core/repositories/user_repository.dart';
// import '../core/repositories/checkin_repository.dart';
// import '../core/repositories/badge_repository.dart';

// class UserProvider with ChangeNotifier {
//   final UserRepository _userRepo = UserRepository();
//   final CheckinRepository _checkinRepo = CheckinRepository();
//   final BadgeRepository _badgeRepo = BadgeRepository();

//   UserModel? _currentUser;
//   bool _isLoading = false;
//   String? _error;

//   // Getters
//   UserModel? get currentUser => _currentUser;
//   bool get isLoading => _isLoading;
//   String? get error => _error;
//   bool get isPremium => _currentUser?.planType == 'premium';

//   // Carregar usuário atual
//   Future<void> loadCurrentUser() async {
//     try {
//       _isLoading = true;
//       notifyListeners();

//       _currentUser = await _userRepo.getCurrentUser();

//       _isLoading = false;
//       notifyListeners();
//     } catch (e) {
//       _error = e.toString();
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   // Criar/Atualizar usuário
//   Future<void> saveUser(UserModel user) async {
//     try {
//       final exists = await _userRepo.exists(user.id);

//       if (exists) {
//         await _userRepo.update(user);
//       } else {
//         await _userRepo.insert(user);
//       }

//       _currentUser = user;
//       notifyListeners();
//     } catch (e) {
//       _error = e.toString();
//       notifyListeners();
//     }
//   }

//   // Atualizar perfil
//   Future<void> updateProfile({
//     String? name,
//     String? username,
//     String? avatarUrl,
//     String? bio,
//     String? phone,
//     String? location,
//   }) async {
//     if (_currentUser == null) return;

//     try {
//       final updatedUser = _currentUser!.copyWith(
//         name: name ?? _currentUser!.name,
//         username: username ?? _currentUser!.username,
//         avatarUrl: avatarUrl ?? _currentUser!.avatarUrl,
//         bio: bio ?? _currentUser!.bio,
//         phone: phone ?? _currentUser!.phone,
//         location: location ?? _currentUser!.location,
//         updatedAt: DateTime.now(),
//       );

//       await _userRepo.update(updatedUser);
//       _currentUser = updatedUser;
//       notifyListeners();
//     } catch (e) {
//       _error = e.toString();
//       notifyListeners();
//     }
//   }

//   // Adicionar pontos
//   Future<void> addPoints(int points) async {
//     if (_currentUser == null) return;

//     try {
//       await _userRepo.updatePoints(_currentUser!.id, points);
//       _currentUser = _currentUser!.copyWith(
//         points: _currentUser!.points + points,
//       );
//       notifyListeners();
//     } catch (e) {
//       _error = e.toString();
//       notifyListeners();
//     }
//   }

//   // Incrementar lugares visitados
//   Future<void> incrementPlacesVisited() async {
//     if (_currentUser == null) return;

//     try {
//       await _userRepo.incrementPlacesVisited(_currentUser!.id);
//       _currentUser = _currentUser!.copyWith(
//         businessesVisited: _currentUser!.businessesVisited + 1,
//       );
//       notifyListeners();
//     } catch (e) {
//       _error = e.toString();
//       notifyListeners();
//     }
//   }

//   // Atualizar streak
//   Future<void> updateStreak() async {
//     if (_currentUser == null) return;

//     try {
//       final streak = await _checkinRepo.getCurrentStreak(_currentUser!.id);
//       await _userRepo.updateStreak(_currentUser!.id, streak);
//       _currentUser = _currentUser!.copyWith(streakDays: streak);
//       notifyListeners();
//     } catch (e) {
//       _error = e.toString();
//       notifyListeners();
//     }
//   }

//   // Upgrade para premium
//   Future<void> upgradeToPremium() async {
//     if (_currentUser == null) return;

//     try {
//       await _userRepo.upgradeToPremium(_currentUser!.id);
//       _currentUser = _currentUser!.copyWith(planType: 'premium');
//       notifyListeners();
//     } catch (e) {
//       _error = e.toString();
//       notifyListeners();
//     }
//   }

//   // Atualizar contagem de badges
//   Future<void> updateBadgesCount() async {
//     if (_currentUser == null) return;

//     try {
//       final count = await _badgeRepo.getBadgesCount(_currentUser!.id);
//       _currentUser = _currentUser!.copyWith(badgesCount: count);
//       notifyListeners();
//     } catch (e) {
//       _error = e.toString();
//       notifyListeners();
//     }
//   }

//   // Logout
//   void logout() {
//     _currentUser = null;
//     notifyListeners();
//   }
// }
