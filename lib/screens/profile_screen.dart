import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../routes.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';
import '../models/user.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();

  User? _currentUser;
  bool _isLoading = true;
  String _errorMessage = '';

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  // Password field is typically not pre-filled for security
  final TextEditingController _passwordController = TextEditingController(); 

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadUserProfile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    try {
      final user = await _authService.getCurrentUser();
      if (user == null) {
        setState(() {
          _errorMessage = 'User not logged in. Please log in.';
          _isLoading = false;
        });
        NavigationHelper.goToLogin(context);
        return;
      }
      setState(() {
        _currentUser = user;
        _nameController.text = user.name;
        _emailController.text = user.email;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load user profile: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _handleUpdateProfile() async {
    if (_currentUser == null) return;

    setState(() {
      _isLoading = true;
    });

    final updatedName = _nameController.text.trim();
    final updatedEmail = _emailController.text.trim();
    final updatedPassword = _passwordController.text.trim();

    if (updatedName.isEmpty || updatedEmail.isEmpty) {
      _showSnackBar('Name and Email cannot be empty.', isError: true);
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final userToUpdate = User(
      id: _currentUser!.id,
      name: updatedName,
      email: updatedEmail,
      password: updatedPassword.isNotEmpty ? updatedPassword : null, // Only send password if updated
    );

    final response = await _userService.updateUser(userToUpdate);

    setState(() {
      _isLoading = false;
    });

    if (response != null && !response.contains('Failed')) {
      _showSnackBar('Profile updated successfully!', isError: false);
      await _authService.refreshCurrentUser(); // Refresh stored user data in AuthService
      setState(() {
        _isEditing = false; // Exit editing mode on success
        _passwordController.clear(); // Clear password field after successful update
      });
      _loadUserProfile(); // Reload profile to ensure UI is consistent
    } else {
      _showSnackBar(response ?? 'Failed to update profile.', isError: true);
    }
  }

  Future<void> _handleLogout() async {
    await _authService.signOut();
    _showSnackBar('Logged out successfully!');
    NavigationHelper.goToLogin(context); // Redirect to login after logout
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => NavigationHelper.goBack(context),
        ),
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          if (!_isLoading) // Only show button when not loading
            TextButton(
              onPressed: () {
                setState(() {
                  _isEditing = !_isEditing;
                  if (!_isEditing) {
                    // If exiting edit mode without saving, reset controllers
                    _nameController.text = _currentUser?.name ?? '';
                    _emailController.text = _currentUser?.email ?? '';
                    _passwordController.clear();
                  }
                });
              },
              child: Text(
                _isEditing ? 'Cancel' : 'Edit',
                style: TextStyle(color: _isEditing ? Colors.redAccent : const Color(0xFF00C896), fontSize: 16),
              ),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF00C896)))
          : _errorMessage.isNotEmpty
              ? Center(
                  child: Text(
                    _errorMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[800],
                          border: Border.all(color: const Color(0xFF00C896), width: 3),
                        ),
                        child: ClipOval(
                          child: SvgPicture.asset(
                            'Icons/profile.svg',
                            fit: BoxFit.cover,
                            colorFilter: const ColorFilter.mode(Colors.white54, BlendMode.srcIn),
                            placeholderBuilder: (context) => const Icon(
                              Icons.person,
                              color: Colors.white54,
                              size: 70,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildProfileField('Name', _nameController, Icons.person, _isEditing),
                      const SizedBox(height: 16),
                      _buildProfileField('Email', _emailController, Icons.email, _isEditing),
                      const SizedBox(height: 16),
                      if (_isEditing) // Show password field only in editing mode
                        _buildProfileField('New Password (optional)', _passwordController, Icons.lock, true, obscureText: true),
                      if (_isEditing) const SizedBox(height: 32),
                      if (_isEditing)
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _handleUpdateProfile,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00C896),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(color: Colors.white) // Show loading on update button
                                : const Text(
                                    'SAVE CHANGES',
                                    style: TextStyle(fontSize: 18, color: Colors.white),
                                  ),
                          ),
                        ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: OutlinedButton(
                          onPressed: _handleLogout,
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.redAccent, width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                          ),
                          child: const Text(
                            'LOGOUT',
                            style: TextStyle(fontSize: 18, color: Colors.redAccent),
                          ),
                        ),
                      ),
                    ],
                  ),
    ),
    );
  }

  Widget _buildProfileField(String label, TextEditingController controller, IconData icon, bool editable, {bool obscureText = false}) {
    return TextField(
      controller: controller,
      readOnly: !editable,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white, fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white54),
        prefixIcon: Icon(icon, color: Colors.white54),
        filled: true,
        fillColor: const Color(0xFF2A2A2A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: editable ? const Color(0xFF00C896) : Colors.transparent, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white, width: 1),
        ),
      ),
    );
  }
}
