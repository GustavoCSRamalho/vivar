// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkin_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckinModel _$CheckinModelFromJson(Map<String, dynamic> json) => CheckinModel(
  id: json['id'] as String,
  placeId: json['placeId'] as String,
  userId: json['userId'] as String,
  pointsEarned: (json['pointsEarned'] as num?)?.toInt() ?? 50,
  rating: (json['rating'] as num?)?.toInt(),
  comment: json['comment'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  synced: json['synced'] as bool? ?? false,
);

Map<String, dynamic> _$CheckinModelToJson(CheckinModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'placeId': instance.placeId,
      'userId': instance.userId,
      'pointsEarned': instance.pointsEarned,
      'rating': instance.rating,
      'comment': instance.comment,
      'createdAt': instance.createdAt.toIso8601String(),
      'synced': instance.synced,
    };
