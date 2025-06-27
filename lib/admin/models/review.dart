// lib/models/review.dart
class Review {
  final String id;
  final String userName;
  final String userImage;
  final int rating;
  final String comment;
  final DateTime timestamp;

  Review({
    required this.id,
    required this.userName,
    required this.userImage,
    required this.rating,
    required this.comment,
    required this.timestamp,
  });
}