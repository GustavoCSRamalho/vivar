// models/favorite_model.dart
class FavoriteModel {
  final String id;
  final String placeId;
  final String userId;
  final DateTime createdAt;
  final bool synced;

  FavoriteModel({
    required this.id,
    required this.placeId,
    required this.userId,
    required this.createdAt,
    this.synced = false,
  });

  factory FavoriteModel.fromMap(Map<String, dynamic> map) {
    return FavoriteModel(
      id: map['id'],
      placeId: map['place_id'],
      userId: map['user_id'],
      createdAt: DateTime.parse(map['created_at']),
      synced: map['synced'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'place_id': placeId,
      'user_id': userId,
      'created_at': createdAt.toIso8601String(),
      'synced': synced ? 1 : 0,
    };
  }
}
