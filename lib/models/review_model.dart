// models/review_model.dart
import 'dart:convert';

class ReviewModel {
  final String id;
  final String placeId;
  final String userId;
  final double rating;
  final String? comment;
  final List<String>? images;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool synced;

  ReviewModel({
    required this.id,
    required this.placeId,
    required this.userId,
    required this.rating,
    this.comment,
    this.images,
    required this.createdAt,
    required this.updatedAt,
    this.synced = false,
  });

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      id: map['id'],
      placeId: map['place_id'],
      userId: map['user_id'],
      rating: map['rating'],
      comment: map['comment'],
      images: map['images'] != null
          ? List<String>.from(jsonDecode(map['images']))
          : null,
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
      synced: map['synced'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'place_id': placeId,
      'user_id': userId,
      'rating': rating,
      'comment': comment,
      'images': images != null ? jsonEncode(images) : null,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'synced': synced ? 1 : 0,
    };
  }
}
