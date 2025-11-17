// domain/entities/register_user_entity.dart

class RegisterUserEntity {
  final String name;
  final String email;
  final String password;
  final String? phone;

  RegisterUserEntity({
    required this.name,
    required this.email,
    required this.password,
    this.phone,
  });
}
