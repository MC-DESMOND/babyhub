import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../models/category.dart'; // Needed for creating dummy category for products
import 'api_config.dart';
import 'auth_service.dart';

class ProductService {
  final AuthService _authService = AuthService();

  Future<List<Product>?> readAllProducts() async {
    final token = await _authService.getToken();
    if (token == null) {
      print('No token found. User not authenticated for products.');
      return null;
    }

    final url = Uri.parse('${ApiConfig.BASE_URL}/product/readall');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> productJson = jsonDecode(response.body);
        // Assuming the backend product JSON includes a 'category' object
        return productJson.map((json) => Product.fromJson(json)).toList();
      } else {
        print('Failed to load products: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error loading products: $e');
      return null;
    }
  }

  // Add create, update, delete methods if needed in the UI
  // Example for creating a product (requires a valid category ID from backend)
  Future<String?> createProduct(Product product) async {
    final token = await _authService.getToken();
    if (token == null) {
      print('No token found. User not authenticated.');
      return 'Authentication required.';
    }

    final url = Uri.parse('${ApiConfig.BASE_URL}/product/create');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(product.toJson()),
      );

      if (response.statusCode == 200) {
        return response.body; // "Product record created successfully."
      } else {
        print('Failed to create product: ${response.statusCode} - ${response.body}');
        return 'Failed to create product: ${response.body}';
      }
    } catch (e) {
      print('Error creating product: $e');
      return 'Error creating product: $e';
    }
  }
}