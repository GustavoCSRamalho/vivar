// models/user_model.dart
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
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
  final int placesVisited;
  final int badgesCount;
  final int streakDays;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool synced;

  UserModel({
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
    this.placesVisited = 0,
    this.badgesCount = 0,
    this.streakDays = 0,
    required this.createdAt,
    required this.updatedAt,
    this.synced = false,
    this.favoriteCount,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  // Converter de Map do SQLite
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      email: map['email'],
      name: map['name'],
      username: map['username'],
      avatarUrl: map['avatar_url'],
      bio: map['bio'],
      favoriteCount: map['favorite_count'],
      phone: map['phone'],
      location: map['location'],
      planType: map['plan_type'] ?? 'free',
      points: map['points'] ?? 0,
      placesVisited: map['places_visited'] ?? 0,
      badgesCount: map['badges_count'] ?? 0,
      streakDays: map['streak_days'] ?? 0,
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
      synced: map['synced'] == 1,
    );
  }

  // Converter para Map do SQLite
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
      'places_visited': placesVisited,
      'badges_count': badgesCount,
      'streak_days': streakDays,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'synced': synced ? 1 : 0,
    };
  }

  UserModel copyWith({
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
    int? placesVisited,
    int? badgesCount,
    int? streakDays,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? synced,
  }) {
    return UserModel(
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
      placesVisited: placesVisited ?? this.placesVisited,
      badgesCount: badgesCount ?? this.badgesCount,
      streakDays: streakDays ?? this.streakDays,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      synced: synced ?? this.synced,
    );
  }
}
