// domain/entities/review_entity.dart

class ReviewEntity {
  final String id;
  final String userId;
  final String placeId;
  final String userName;
  final String? userAvatarUrl;
  final double rating;
  final String comment;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String>? images;

  ReviewEntity({
    required this.id,
    required this.userId,
    required this.placeId,
    required this.userName,
    this.userAvatarUrl,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.updatedAt,
    this.images,
  });

  bool get hasImages => images != null && images!.isNotEmpty;

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} ano${(difference.inDays / 365).floor() > 1 ? 's' : ''} atrás';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} mês${(difference.inDays / 30).floor() > 1 ? 'es' : ''} atrás';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} dia${difference.inDays > 1 ? 's' : ''} atrás';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hora${difference.inHours > 1 ? 's' : ''} atrás';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minuto${difference.inMinutes > 1 ? 's' : ''} atrás';
    } else {
      return 'Agora';
    }
  }
}
