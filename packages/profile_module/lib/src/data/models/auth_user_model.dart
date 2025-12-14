// models/user_model.dart

class AuthUserModel {
  final String id;
  final String email;
  final String name;
  final String? username;
  final String? avatarUrl;
  final String? bio;
  final String? phone;
  final int? favoriteCount;
  final String? location;
  final String planType; // 'free' ou 'premium'
  final int points;
  final int businessesVisited;
  final int badgesCount;
  final int streakDays;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool synced;

  AuthUserModel({
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
    required this.createdAt,
    required this.updatedAt,
    this.synced = false,
    this.favoriteCount,
  });

  factory AuthUserModel.fromMap(Map<String, dynamic> map) {
    return AuthUserModel(
      id: map['id'] as String,
      email: map['email'] as String,
      name: map['name'] as String,
      username: map['username'] as String?,
      avatarUrl: map['avatar_url'] as String?,
      bio: map['bio'] as String?,
      phone: map['phone'] as String?,
      favoriteCount: map['favorite_count'] as int?,
      location: map['location'] as String?,
      planType: map['plan_type'] as String? ?? 'free',
      points: map['points'] as int? ?? 0,
      businessesVisited: map['businesses_visited'] as int? ?? 0,
      badgesCount: map['badges_count'] as int? ?? 0,
      streakDays: map['streak_days'] as int? ?? 0,
      createdAt: map['created_at'] is String
          ? DateTime.parse(map['created_at'])
          : (map['created_at'] as DateTime),
      updatedAt: map['updated_at'] is String
          ? DateTime.parse(map['updated_at'])
          : (map['updated_at'] as DateTime),
      synced: map['synced'] is int
          ? (map['synced'] as int) == 1
          : (map['synced'] as bool? ?? false),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'username': username,
      'avatar_url': avatarUrl,
      'bio': bio,
      'favorite_count': favoriteCount,
      'phone': phone,
      'location': location,
      'plan_type': planType,
      'points': points,
      'businesses_visited': businessesVisited,
      'badges_count': badgesCount,
      'streak_days': streakDays,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'synced': synced ? 1 : 0,
    };
  }

  AuthUserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? username,
    String? avatarUrl,
    String? bio,
    String? phone,
    String? location,
    String? planType,
    int? favoriteCount,
    int? points,
    int? businessesVisited,
    int? badgesCount,
    int? streakDays,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? synced,
  }) {
    return AuthUserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      favoriteCount: favoriteCount ?? this.favoriteCount,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      planType: planType ?? this.planType,
      points: points ?? this.points,
      businessesVisited: businessesVisited ?? this.businessesVisited,
      badgesCount: badgesCount ?? this.badgesCount,
      streakDays: streakDays ?? this.streakDays,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      synced: synced ?? this.synced,
    );
  }
}
