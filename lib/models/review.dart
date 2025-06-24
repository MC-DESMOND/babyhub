
class Review {
  final int id;
  final int productId;
  final int userId;
  final String reviewerName;
  final String text;
  final int rating;
  final DateTime reviewDate;

  Review({
    required this.id,
    required this.productId,
    required this.userId,
    required this.reviewerName,
    required this.text,
    required this.rating,
    required this.reviewDate,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      productId: json['productId'],
      userId: json['userId'],
      reviewerName: json['reviewerName'],
      text: json['text'],
      rating: json['rating'],
      // Parse LocalDateTime string from backend (e.g., "2023-10-27T10:00:00")
      reviewDate: DateTime.parse(json['reviewDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'userId': userId,
      'reviewerName': reviewerName,
      'text': text,
      'rating': rating,
      'reviewDate': reviewDate.toIso8601String(), // Convert to ISO 8601 string for backend
    };
  }
}
