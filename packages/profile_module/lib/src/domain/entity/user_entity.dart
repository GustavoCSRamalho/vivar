// domain/entities/user_entity.dart

/// Entidade de domínio para User
class UserEntity {
  final String id;
  final String email;
  final String name;
  final String? username;
  final String? avatarUrl;
  final String? bio;
  final String? phone;
  final String? location;
  final String planType;
  final int points;
  final int businessesVisited;
  final int badgesCount;
  final int streakDays;
  final int? favoriteCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserEntity({
    required this.id,
    required this.email,
    required this.name,
    this.username,
    this.avatarUrl,
    this.bio,
    this.phone,
    this.location,
    this.planType = 'free',
    this.points = 0,
    this.businessesVisited = 0,
    this.badgesCount = 0,
    this.streakDays = 0,
    this.favoriteCount,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Verifica se o usuário é premium
  bool get isPremium => planType == 'premium';

  /// Retorna o nível do usuário baseado em pontos
  String get level {
    if (points < 100) return 'Iniciante';
    if (points < 500) return 'Explorador';
    if (points < 1000) return 'Aventureiro';
    if (points < 5000) return 'Expert';
    return 'Lenda';
  }

  /// Retorna a localização ou padrão
  String get displayLocation => location ?? 'São Paulo, SP';
}
