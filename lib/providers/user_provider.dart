import 'package:flutter/material.dart';
import '../models/user_model.dart';

class UserProvider extends ChangeNotifier {
  UserModel _user = const UserModel(
    name: 'John Doe',
    email: 'john.doe@example.com',
    phone: '+1 234 567 8900',
  );

  bool _isLoading = false;

  // Getters
  UserModel get user => _user;
  bool get isLoading => _isLoading;

  // Methods to update user information
  void updateUser(UserModel newUser) {
    _user = newUser;
    notifyListeners();
  }

  void updatePersonalInfo({
    String? name,
    String? email,
    String? phone,
  }) {
    _user = _user.copyWith(
      name: name ?? _user.name,
      email: email ?? _user.email,
      phone: phone ?? _user.phone,
    );
    notifyListeners();
  }

  void updatePassword(String currentPassword, String newPassword) {
    _user = _user.copyWith(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}