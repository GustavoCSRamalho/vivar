// domain/entities/user_profile_update_entity.dart

class UserProfileUpdateEntity {
  final String userId;
  final String name;
  final String? username;
  final String? bio;
  final String? phone;
  final String? location;
  final String? avatarUrl;
  final List<String>? interests;
  final Map<String, bool>? privacySettings;

  UserProfileUpdateEntity({
    required this.userId,
    required this.name,
    this.username,
    this.bio,
    this.phone,
    this.location,
    this.avatarUrl,
    this.interests,
    this.privacySettings,
  });
}
