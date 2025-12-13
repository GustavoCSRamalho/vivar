// domain/entities/auth_user_entity.dart

class AuthUserEntity {
  final String id;
  final String email;
  final String name;
  final String? avatarUrl;
  final String? phone;
  final DateTime createdAt;

  AuthUserEntity({
    required this.id,
    required this.email,
    required this.name,
    this.avatarUrl,
    this.phone,
    required this.createdAt,
  });
}
