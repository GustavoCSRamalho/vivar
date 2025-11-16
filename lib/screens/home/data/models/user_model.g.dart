// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: json['id'] as String,
  email: json['email'] as String,
  name: json['name'] as String,
  username: json['username'] as String?,
  avatarUrl: json['avatarUrl'] as String?,
  bio: json['bio'] as String?,
  phone: json['phone'] as String?,
  location: json['location'] as String?,
  planType: json['planType'] as String? ?? 'free',
  points: (json['points'] as num?)?.toInt() ?? 0,
  placesVisited: (json['placesVisited'] as num?)?.toInt() ?? 0,
  badgesCount: (json['badgesCount'] as num?)?.toInt() ?? 0,
  streakDays: (json['streakDays'] as num?)?.toInt() ?? 0,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  synced: json['synced'] as bool? ?? false,
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'name': instance.name,
  'username': instance.username,
  'avatarUrl': instance.avatarUrl,
  'bio': instance.bio,
  'phone': instance.phone,
  'location': instance.location,
  'planType': instance.planType,
  'points': instance.points,
  'placesVisited': instance.placesVisited,
  'badgesCount': instance.badgesCount,
  'streakDays': instance.streakDays,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'synced': instance.synced,
};
