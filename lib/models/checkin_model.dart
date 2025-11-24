// models/checkin_model.dart

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

  factory CheckinModel.fromMap(Map<String, dynamic> map) {
    return CheckinModel(
      id: map['id'] as String,
      placeId: map['place_id'] as String,
      userId: map['user_id'] as String,
      pointsEarned: map['points_earned'] as int? ?? 50,
      rating: map['rating'] as int?,
      comment: map['comment'] as String?,
      createdAt: map['created_at'] is String
          ? DateTime.parse(map['created_at'])
          : (map['created_at'] as DateTime),
      synced: map['synced'] is int
          ? (map['synced'] as int) == 1
          : (map['synced'] as bool? ?? false),
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

  CheckinModel copyWith({
    String? id,
    String? placeId,
    String? userId,
    int? pointsEarned,
    int? rating,
    String? comment,
    DateTime? createdAt,
    bool? synced,
  }) {
    return CheckinModel(
      id: id ?? this.id,
      placeId: placeId ?? this.placeId,
      userId: userId ?? this.userId,
      pointsEarned: pointsEarned ?? this.pointsEarned,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
      synced: synced ?? this.synced,
    );
  }
}
