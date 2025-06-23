import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/login_request.dart';
import '../models/jwt_response.dart';
import '../models/user.dart';
import 'api_config.dart';

class AuthService {
  static const String _tokenKey = 'jwt_token';
  static const String _userIdKey = 'user_id';
  static const String _userNameKey = 'user_name';
  static const String _userEmailKey = 'user_email';

  Future<JwtResponse?> signIn(LoginRequest loginRequest) async {
    final url = Uri.parse('${ApiConfig.BASE_URL}/auth/signin');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(loginRequest.toJson()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final jwtResponse = JwtResponse.fromJson(data);
        await _saveToken(jwtResponse);
        return jwtResponse;
      } else {
        print('Failed to sign in: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error during sign in: $e');
      return null;
    }
  }

  Future<void> _saveToken(JwtResponse jwtResponse) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, jwtResponse.token);
    await prefs.setInt(_userIdKey, jwtResponse.id);
    await prefs.setString(_userNameKey, jwtResponse.name);
    await prefs.setString(_userEmailKey, jwtResponse.email);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt(_userIdKey);
    final userName = prefs.getString(_userNameKey);
    final userEmail = prefs.getString(_userEmailKey);

    if (userId != null && userName != null && userEmail != null) {
      return User(id: userId, name: userName, email: userEmail);
    }
    return null;
  }

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_userNameKey);
    await prefs.remove(_userEmailKey);
    print('User signed out.');
  }
}