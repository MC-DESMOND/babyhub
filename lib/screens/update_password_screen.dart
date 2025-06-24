import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../providers/user_provider.dart';

// Local GetxController for password-specific state management
class UpdatePasswordProvider extends GetxController {
  RxString _currentPassword = ''.obs;
  RxString _newPassword = ''.obs;
  RxString _confirmPassword = ''.obs;
  RxBool _isLoading = false.obs;
  RxBool _isCurrentPasswordVisible = false.obs;
  RxBool _isNewPasswordVisible = false.obs;
  RxBool _isConfirmPasswordVisible = false.obs;
  RxBool _hasMinLength = false.obs;
  RxBool _hasNumber = false.obs;
  RxBool _hasLetters = false.obs;
  RxnString _errorMessage = RxnString();

  String get currentPassword => _currentPassword.value;
  String get newPassword => _newPassword.value;
  String get confirmPassword => _confirmPassword.value;
  bool get isLoading => _isLoading.value;
  bool get isCurrentPasswordVisible => _isCurrentPasswordVisible.value;
  bool get isNewPasswordVisible => _isNewPasswordVisible.value;
  bool get isConfirmPasswordVisible => _isConfirmPasswordVisible.value;
  bool get hasMinLength => _hasMinLength.value;
  bool get hasNumber => _hasNumber.value;
  bool get hasLetters => _hasLetters.value;
  String? get errorMessage => _errorMessage.value;

  bool get isFormValid {
    return _currentPassword.isNotEmpty &&
        _newPassword.isNotEmpty &&
        _confirmPassword.isNotEmpty &&
        _hasMinLength.value &&
        _hasNumber.value &&
        _hasLetters.value &&
        _newPassword.value == _confirmPassword.value;
  }

  void updateCurrentPassword(String password) {
    _currentPassword.value = password;
    _clearError();
  }

  void updateNewPassword(String password) {
    _newPassword.value = password;
    _validateNewPassword(password);
    _clearError();
  }

  void updateConfirmPassword(String password) {
    _confirmPassword.value = password;
    _clearError();
  }

  void toggleCurrentPasswordVisibility() {
    _isCurrentPasswordVisible.value = !_isCurrentPasswordVisible.value;
  }

  void toggleNewPasswordVisibility() {
    _isNewPasswordVisible.value = !_isNewPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    _isConfirmPasswordVisible.value = !_isConfirmPasswordVisible.value;
  }

  void _validateNewPassword(String password) {
    _hasMinLength.value = password.length >= 8;
    _hasNumber.value = password.contains(RegExp(r'[0-9]'));
    _hasLetters.value = password.contains(RegExp(r'[a-zA-Z]'));
  }

  void setLoading(bool loading) {
    _isLoading.value = loading;
  }

  void setError(String error) {
    _errorMessage.value = error;
  }

  void _clearError() {
    if (_errorMessage.value != null) {
      _errorMessage.value = null;
    }
  }

  Future<bool> updatePassword(UserProvider userProvider) async {
    if (!isFormValid) {
      setError('Please fill all fields correctly');
      return false;
    }
    if (_newPassword.value != _confirmPassword.value) {
      setError('New passwords do not match');
      return false;
    }
    setLoading(true);
    try {
      // In a real scenario, you'd send currentPassword and newPassword to backend for validation
      bool success = await userProvider.updatePassword(_currentPassword.value, _newPassword.value);
      if (success) {
        _clearError();
        resetForm(); // Reset form on success
        return true;
      } else {
        setError(userProvider.errorMessage ?? 'Current password is incorrect or failed to update.');
        return false;
      }
    } catch (e) {
      setError('Failed to update password. Please try again.');
      return false;
    } finally {
      setLoading(false);
    }
  }

  void resetForm() {
    _currentPassword.value = '';
    _newPassword.value = '';
    _confirmPassword.value = '';
    _hasMinLength.value = false;
    _hasNumber.value = false;
    _hasLetters.value = false;
    _errorMessage.value = null;
    _isCurrentPasswordVisible.value = false;
    _isNewPasswordVisible.value = false;
    _isConfirmPasswordVisible.value = false;
  }
}

class UpdatePasswordScreen extends StatelessWidget {
  const UpdatePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UpdatePasswordProvider>( // Use GetBuilder for the screen
      init: UpdatePasswordProvider(), // Initialize the controller
      builder: (provider) => _UpdatePasswordScreenContent(),
    );
  }
}

class _UpdatePasswordScreenContent extends StatelessWidget {
  const _UpdatePasswordScreenContent();

  @override
  Widget build(BuildContext context) {
    final userProvider = Get.find<UserProvider>(); // Access UserProvider
    final provider = Get.find<UpdatePasswordProvider>(); // Access local password provider

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: const Color(0xFF2D2D2D),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white70, size: 18),
            onPressed: () => context.pop(),
          ),
        ),
        title: const Text(
          'Update Password',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx( // Use Obx to react to changes in the controller's Rx variables
        () => SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionTitle(title: 'Your Current Password'),
              const SizedBox(height: 12),
              _PasswordField(
                hintText: 'Current password',
                isVisible: provider.isCurrentPasswordVisible,
                onChanged: provider.updateCurrentPassword,
                onToggleVisibility: provider.toggleCurrentPasswordVisibility,
              ),
              const SizedBox(height: 24),
              const _SectionTitle(title: 'Your New Password'),
              const SizedBox(height: 12),
              _PasswordField(
                hintText: 'New password',
                isVisible: provider.isNewPasswordVisible,
                onChanged: provider.updateNewPassword,
                onToggleVisibility: provider.toggleNewPasswordVisibility,
              ),
              const SizedBox(height: 24),
              const _SectionTitle(title: 'Confirm New Password'),
              const SizedBox(height: 12),
              _PasswordField(
                hintText: 'Re-enter your new password',
                isVisible: provider.isConfirmPasswordVisible,
                onChanged: provider.updateConfirmPassword,
                onToggleVisibility: provider.toggleConfirmPasswordVisibility,
              ),
              const SizedBox(height: 32),
              _PasswordRequirements(
                hasMinLength: provider.hasMinLength,
                hasNumber: provider.hasNumber,
                hasLetters: provider.hasLetters,
              ),
              const SizedBox(height: 24),
              if (provider.errorMessage != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.withOpacity(0.3)),
                  ),
                  child: Text(
                    provider.errorMessage!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                    ),
                  ),
                ),
              const SizedBox(height: 32),
              _UpdateButton(
                isEnabled: provider.isFormValid,
                isLoading: provider.isLoading,
                onPressed: () => _handleUpdatePassword(context, provider, userProvider),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> _handleUpdatePassword(
  BuildContext context,
  UpdatePasswordProvider provider,
  UserProvider userProvider,
) async {
  final success = await provider.updatePassword(userProvider);
  if (success && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Password updated successfully!'),
        backgroundColor: Color(0xFF4CAF50),
        duration: Duration(seconds: 2),
      ),
    );
    Future.delayed(const Duration(milliseconds: 500), () {
      if (context.mounted) {
        context.pop();
      }
    });
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  final String hintText;
  final bool isVisible;
  final Function(String) onChanged;
  final VoidCallback onToggleVisibility;

  const _PasswordField({
    required this.hintText,
    required this.isVisible,
    required this.onChanged,
    required this.onToggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        obscureText: !isVisible,
        onChanged: onChanged,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Colors.white38,
            fontSize: 16,
          ),
          prefixIcon: const Icon(
            Icons.lock_outline,
            color: Colors.white38,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              isVisible ? Icons.visibility_off : Icons.visibility,
              color: Colors.white38,
            ),
            onPressed: onToggleVisibility,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}

class _PasswordRequirements extends StatelessWidget {
  final bool hasMinLength;
  final bool hasNumber;
  final bool hasLetters;

  const _PasswordRequirements({
    required this.hasMinLength,
    required this.hasNumber,
    required this.hasLetters,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _RequirementItem(
          text: 'Minimum 8 characters',
          isValid: hasMinLength,
        ),
        const SizedBox(height: 8),
        _RequirementItem(
          text: 'At least 1 number (1-9)',
          isValid: hasNumber,
        ),
        const SizedBox(height: 8),
        _RequirementItem(
          text: 'At least lowercase or uppercase letters',
          isValid: hasLetters,
        ),
      ],
    );
  }
}

class _RequirementItem extends StatelessWidget {
  final String text;
  final bool isValid;

  const _RequirementItem({
    required this.text,
    required this.isValid,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          isValid ? Icons.check : Icons.close,
          color: isValid ? Colors.green : Colors.red,
          size: 20,
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: TextStyle(
            color: isValid ? Colors.green : Colors.red,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class _UpdateButton extends StatelessWidget {
  final bool isEnabled;
  final bool isLoading;
  final VoidCallback onPressed;

  const _UpdateButton({
    required this.isEnabled,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isEnabled && !isLoading ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4CAF50),
          disabledBackgroundColor: Colors.grey.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                'Update Password',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}