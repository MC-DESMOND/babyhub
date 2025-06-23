import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import 'api_config.dart';
import 'auth_service.dart';

class CategoryService {
  final AuthService _authService = AuthService();

  Future<List<Category>?> readAllCategories() async {
    final token = await _authService.getToken();
    if (token == null) {
      print('[DEV] No token found. User not authenticated for categories.');
      return null; // Or handle re-authentication
    }

    final url = Uri.parse('${ApiConfig.BASE_URL}/category/readall');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> categoryJson = jsonDecode(response.body);
        print('[DEV] Categories loaded successfully: ${categoryJson.length} categories found.');
        if (categoryJson.isEmpty) {
          print('[DEV] No categories found.');
          return [];
        }
        return categoryJson.map((json) => Category.fromJson(json)).toList();
      } else {
        print('[DEV] Failed to load categories: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('[DEV] Error loading categories: $e');
      return null;
    }
  }

  // Add create, update, delete methods if needed in the UI
}