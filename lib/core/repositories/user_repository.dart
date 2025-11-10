// core/repositories/user_repository.dart
import '../database/database_helper.dart';
import '../../models/user_model.dart';
import 'base_repository.dart';

class UserRepository extends BaseRepository<UserModel> {
  @override
  String get tableName => 'users';

  @override
  UserModel fromMap(Map<String, dynamic> map) => UserModel.fromMap(map);

  @override
  Map<String, dynamic> toMap(UserModel model) => model.toMap();

  // Métodos específicos de usuário
  Future<UserModel?> getCurrentUser() async {
    final users = await getAll();
    return users.isNotEmpty ? users.first : null;
  }

  Future<UserModel?> getUserByEmail(String email) async {
    final users = await getWhere('email = ?', [email]);
    return users.isNotEmpty ? users.first : null;
  }

  Future<int> updatePoints(String userId, int points) async {
    final db = await database;
    return await db.rawUpdate(
      'UPDATE $tableName SET points = points + ? WHERE id = ?',
      [points, userId],
    );
  }

  Future<int> incrementPlacesVisited(String userId) async {
    final db = await database;
    return await db.rawUpdate(
      'UPDATE $tableName SET places_visited = places_visited + 1 WHERE id = ?',
      [userId],
    );
  }

  Future<int> incrementBadgesCount(String userId) async {
    final db = await database;
    return await db.rawUpdate(
      'UPDATE $tableName SET badges_count = badges_count + 1 WHERE id = ?',
      [userId],
    );
  }

  Future<int> updateStreak(String userId, int days) async {
    final db = await database;
    return await db.update(
      tableName,
      {'streak_days': days},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  Future<int> upgradeToPremium(String userId) async {
    final db = await database;
    return await db.update(
      tableName,
      {'plan_type': 'premium', 'updated_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }
}
