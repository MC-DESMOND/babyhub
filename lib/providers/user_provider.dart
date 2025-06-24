import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';

class UserProvider extends GetxController {
  Rxn<User> _user = Rxn<User>();
  RxBool _isLoading = false.obs;
  RxnString _errorMessage = RxnString();

  final AuthService _authService = AuthService();
  final UserService _userService = UserService();

  User get user {
    return _user.value ?? User(id: 0, name: 'Guest', email: 'guest@example.com');
  }

  bool get isLoading => _isLoading.value;
  String? get errorMessage => _errorMessage.value;

  @override
  void onInit() {
    super.onInit();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    setLoading(true);
    try {
      _user.value = await _authService.getCurrentUser();
      if (_user.value == null) {
        setErrorMessage('User not logged in or session expired.');
      } else {
        setErrorMessage(null);
      }
    } catch (e) {
      setErrorMessage('Failed to load user: $e');
      print('Error loading user in UserProvider: $e');
    } finally {
      setLoading(false);
    }
  }

  void setLoading(bool value) {
    _isLoading.value = value;
  }

  void setErrorMessage(String? message) {
    _errorMessage.value = message;
  }

  // Method to update personal information (name, email)
  Future<bool> updatePersonalInfo({
    required String name,
    required String email,
  }) async {
    if (_user.value == null) {
      setErrorMessage('No user logged in.');
      return false;
    }
    setLoading(true);
    try {
      final updatedUser = User(
        id: _user.value!.id,
        name: name,
        email: email,
        password: null, // Password is handled separately
      );
      final response = await _userService.updateUser(updatedUser);
      if (response != null && !response.contains('Failed')) {
        await _authService.refreshCurrentUser(); // Reload data from shared preferences
        _user.value = await _authService.getCurrentUser(); // Update provider's user instance
        setErrorMessage(null);
        return true;
      } else {
        setErrorMessage(response ?? 'Failed to update personal information.');
        return false;
      }
    } catch (e) {
      setErrorMessage('Error updating personal information: $e');
      return false;
    } finally {
      setLoading(false);
    }
  }

  // Method to update password
  Future<bool> updatePassword(String oldPassword, String newPassword) async {
    if (_user.value == null) {
      setErrorMessage('No user logged in.');
      return false;
    }
    setLoading(true);
    try {
      final updatedUserWithNewPassword = User(
        id: _user.value!.id,
        name: _user.value!.name,
        email: _user.value!.email,
        password: newPassword, // Send new password
      );
      final response = await _userService.updateUser(updatedUserWithNewPassword);
      if (response != null && !response.contains('Failed')) {
        await _authService.refreshCurrentUser(); // Update local user info
        _user.value = await _authService.getCurrentUser();
        setErrorMessage(null);
        return true;
      } else {
        setErrorMessage(response ?? 'Failed to update password.');
        return false;
      }
    } catch (e) {
      setErrorMessage('Error updating password: $e');
      return false;
    } finally {
      setLoading(false);
    }
  }

  // Method for logout
  Future<void> logout() async {
    setLoading(true);
    await _authService.signOut();
    _user.value = null;
    setErrorMessage(null);
    setLoading(false);
  }
}