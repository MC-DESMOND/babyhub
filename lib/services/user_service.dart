import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import 'api_config.dart';
import 'auth_service.dart';

class UserService {
  final AuthService _authService = AuthService();

  Future<String?> createUser(User user) async {
    final url = Uri.parse('${ApiConfig.BASE_URL}/user/create');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 200) {
        return response.body; // Expecting "User record created successfully."
      } else {
        print('Failed to create user: ${response.statusCode} - ${response.body}');
        return 'Failed to create user: ${response.body}';
      }
    } catch (e) {
      print('Error creating user: $e');
      return 'Error creating user: $e';
    }
  }

  // Example of an authenticated request (if needed later for user updates/reads)
  Future<List<User>?> getAllUsers() async {
    final token = await _authService.getToken();
    if (token == null) {
      print('No token found. User not authenticated.');
      return null;
    }

    final url = Uri.parse('${ApiConfig.BASE_URL}/user/readall');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> userJson = jsonDecode(response.body);
        return userJson.map((json) => User.fromJson(json)).toList();
      } else {
        print('Failed to load users: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error loading users: $e');
      return null;
    }
  }
}