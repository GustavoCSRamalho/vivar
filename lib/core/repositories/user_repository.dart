// // core/repositories/user_repository.dart
// import '../../../packages/database_module/lib/src/database_helper.dart';
// import '../../../packages/home_module/lib/src/data/models/user_model.dart';
// import 'base_repository.dart';

// // core/repositories/protocols/user_protocols.dart

// // Arquivo: current_user_reader_protocol.dart
// /// Protocolo para leitura do usuário atual
// abstract class CurrentUserReaderProtocol {
//   /// Retorna o usuário atual logado
//   Future<UserModel?> getCurrentUser();
// }

// // Arquivo: user_finder_protocol.dart
// /// Protocolo para busca de usuários
// abstract class UserFinderProtocol {
//   /// Busca usuário por email
//   Future<UserModel?> getUserByEmail(String email);
// }

// // Arquivo: user_points_manager_protocol.dart
// /// Protocolo para gerenciamento de pontos do usuário
// abstract class UserPointsManagerProtocol {
//   /// Atualiza os pontos do usuário (incrementa ou decrementa)
//   Future<int> updatePoints(String userId, int points);
// }

// // Arquivo: user_statistics_updater_protocol.dart
// /// Protocolo para atualização de estatísticas do usuário
// abstract class UserStatisticsUpdaterProtocol {
//   /// Incrementa o contador de lugares visitados
//   Future<int> incrementBusinessesVisited(String userId);

//   /// Incrementa o contador de badges conquistados
//   Future<int> incrementBadgesCount(String userId);

//   /// Atualiza o streak de dias consecutivos
//   Future<int> updateStreak(String userId, int days);
// }

// // Arquivo: user_plan_manager_protocol.dart
// /// Protocolo para gerenciamento de plano do usuário
// abstract class UserPlanManagerProtocol {
//   /// Atualiza o usuário para o plano premium
//   Future<int> upgradeToPremium(String userId);
// }

// // ============================================
// // IMPLEMENTAÇÃO NO REPOSITORY
// // ============================================

// class UserRepository extends BaseRepository<UserModel>
//     implements
//         CurrentUserReaderProtocol,
//         UserFinderProtocol,
//         UserPointsManagerProtocol,
//         UserStatisticsUpdaterProtocol,
//         UserPlanManagerProtocol {
//   @override
//   String get tableName => 'users';

//   @override
//   UserModel fromMap(Map<String, dynamic> map) => UserModel.fromMap(map);

//   @override
//   Map<String, dynamic> toMap(UserModel model) => model.toMap();

//   // Métodos específicos de usuário
//   @override
//   Future<UserModel?> getCurrentUser() async {
//     final users = await getAll();
//     return users.isNotEmpty ? users.first : null;
//   }

//   @override
//   Future<UserModel?> getUserByEmail(String email) async {
//     final users = await getWhere('email = ?', [email]);
//     return users.isNotEmpty ? users.first : null;
//   }

//   @override
//   Future<int> updatePoints(String userId, int points) async {
//     final db = await database;
//     return await db.rawUpdate(
//       'UPDATE $tableName SET points = points + ? WHERE id = ?',
//       [points, userId],
//     );
//   }

//   @override
//   Future<int> incrementBusinessesVisited(String userId) async {
//     final db = await database;
//     return await db.rawUpdate(
//       'UPDATE $tableName SET businesses_visited = businesses_visited + 1 WHERE id = ?',
//       [userId],
//     );
//   }

//   @override
//   Future<int> incrementBadgesCount(String userId) async {
//     final db = await database;
//     return await db.rawUpdate(
//       'UPDATE $tableName SET badges_count = badges_count + 1 WHERE id = ?',
//       [userId],
//     );
//   }

//   @override
//   Future<int> updateStreak(String userId, int days) async {
//     final db = await database;
//     return await db.update(
//       tableName,
//       {'streak_days': days},
//       where: 'id = ?',
//       whereArgs: [userId],
//     );
//   }

//   @override
//   Future<int> upgradeToPremium(String userId) async {
//     final db = await database;
//     return await db.update(
//       tableName,
//       {'plan_type': 'premium', 'updated_at': DateTime.now().toIso8601String()},
//       where: 'id = ?',
//       whereArgs: [userId],
//     );
//   }
// }
