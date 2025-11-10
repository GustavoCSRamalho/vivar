// models/checkin_model.dart
import 'package:json_annotation/json_annotation.dart';

part 'checkin_model.g.dart';

@JsonSerializable()
class CheckinModel {
  final String id;
  final String placeId;
  final String userId;
  final int pointsEarned;
  final int? rating;
  final String? comment;
  final DateTime createdAt;
  final bool synced;

  CheckinModel({
    required this.id,
    required this.placeId,
    required this.userId,
    this.pointsEarned = 50,
    this.rating,
    this.comment,
    required this.createdAt,
    this.synced = false,
  });

  factory CheckinModel.fromJson(Map<String, dynamic> json) =>
      _$CheckinModelFromJson(json);

  Map<String, dynamic> toJson() => _$CheckinModelToJson(this);

  factory CheckinModel.fromMap(Map<String, dynamic> map) {
    return CheckinModel(
      id: map['id'],
      placeId: map['place_id'],
      userId: map['user_id'],
      pointsEarned: map['points_earned'] ?? 50,
      rating: map['rating'],
      comment: map['comment'],
      createdAt: DateTime.parse(map['created_at']),
      synced: map['synced'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'place_id': placeId,
      'user_id': userId,
      'points_earned': pointsEarned,
      'rating': rating,
      'comment': comment,
      'created_at': createdAt.toIso8601String(),
      'synced': synced ? 1 : 0,
    };
  }
}
