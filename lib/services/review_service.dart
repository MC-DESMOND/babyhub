import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/review.dart';
import 'api_config.dart';
import 'auth_service.dart';

class ReviewService {
  final AuthService _authService = AuthService();

  Future<String?> createReview(int userId, int productId, String text, int rating) async {
    final token = await _authService.getToken();
    if (token == null) {
      print('No token found. User not authenticated for creating review.');
      return 'Authentication required.';
    }

    final url = Uri.parse('${ApiConfig.BASE_URL}/reviews/create');
    final reviewData = {
      'userId': userId,
      'productId': productId,
      'text': text,
      'rating': rating,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(reviewData),
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        print('Failed to create review: ${response.statusCode} - ${response.body}');
        return 'Failed to create review: ${response.body}';
      }
    } catch (e) {
      print('Error creating review: $e');
      return 'Error creating review: $e';
    }
  }

  Future<List<Review>?> getReviewsForProduct(int productId) async {
    // Reviews can be publicly viewed, so token is optional, but good practice if it's protected.
    final token = await _authService.getToken();

    final url = Uri.parse('${ApiConfig.BASE_URL}/reviews/product/$productId');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> reviewsJson = jsonDecode(response.body);
        return reviewsJson.map((json) => Review.fromJson(json)).toList();
      } else if (response.statusCode == 404) {
        print('Product not found or no reviews for product $productId: ${response.body}');
        return []; // Return empty list if product exists but no reviews, or product not found.
      } else {
        print('Failed to load reviews: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error loading reviews: $e');
      return null;
    }
  }
}
