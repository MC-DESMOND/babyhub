import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cart.dart';
// Import CartItem for consistency
import 'api_config.dart';
import 'auth_service.dart';

class CartService {
  final AuthService _authService = AuthService();

  Future<String?> _performAuthenticatedRequest(
      Future<http.Response> Function(String token) requestBuilder) async {
    final token = await _authService.getToken();
    if (token == null) {
      print('No token found. User not authenticated for cart operations.');
      return 'Authentication required.';
    }
    try {
      final response = await requestBuilder(token);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        print('Failed: ${response.statusCode} - ${response.body}');
        return 'Failed: ${response.body}';
      }
    }
   catch (e) {
      print('Error: $e');
      return 'Error: $e';
    }
  }

  Future<String?> addItemToCart(int userId, int productId, int quantity) async {
    return await _performAuthenticatedRequest((token) async {
      final url = Uri.parse('${ApiConfig.BASE_URL}/cart/add/$userId/$productId/$quantity');
      return await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
    });
  }

  Future<String?> updateCartItemQuantity(int userId, int productId, int newQuantity) async {
    return await _performAuthenticatedRequest((token) async {
      final url = Uri.parse('${ApiConfig.BASE_URL}/cart/update/$userId/$productId/$newQuantity');
      return await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
    });
  }

  Future<String?> removeItemFromCart(int userId, int productId) async {
    return await _performAuthenticatedRequest((token) async {
      final url = Uri.parse('${ApiConfig.BASE_URL}/cart/remove/$userId/$productId');
      return await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
    });
  }

  Future<Cart?> getCartByUserId(int userId) async {
    final token = await _authService.getToken();
    if (token == null) {
      print('No token found. User not authenticated for cart details.');
      return null;
    }
    try {
      final url = Uri.parse('${ApiConfig.BASE_URL}/cart/$userId');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> cartJson = jsonDecode(response.body);
        return Cart.fromJson(cartJson);
      } else if (response.statusCode == 404) {
        print('Cart not found for user $userId (might be empty or not yet created): ${response.body}');
        return Cart(
          userId: userId,
          cartItems: [],
          totalCost: 0.0,
        ); // Return empty cart for 404
      } else {
        print('Failed to load cart: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error loading cart: $e');
      return null;
    }
  }

  Future<String?> clearCart(int userId) async {
    return await _performAuthenticatedRequest((token) async {
      final url = Uri.parse('${ApiConfig.BASE_URL}/cart/clear/$userId');
      return await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
    });
  }
}
