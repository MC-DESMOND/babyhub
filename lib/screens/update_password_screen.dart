import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/user_provider.dart';

// Local provider for password-specific state management
class UpdatePasswordProvider extends ChangeNotifier {
  // Private fields
  String _currentPassword = '';
  String _newPassword = '';
  String _confirmPassword = '';
  bool _isLoading = false;
  bool _isCurrentPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // Form validation state
  bool _hasMinLength = false;
  bool _hasNumber = false;
  bool _hasLetters = false;
  String? _errorMessage;

  // Getters
  String get currentPassword => _currentPassword;
  String get newPassword => _newPassword;
  String get confirmPassword => _confirmPassword;
  bool get isLoading => _isLoading;
  bool get isCurrentPasswordVisible => _isCurrentPasswordVisible;
  bool get isNewPasswordVisible => _isNewPasswordVisible;
  bool get isConfirmPasswordVisible => _isConfirmPasswordVisible;
  bool get hasMinLength => _hasMinLength;
  bool get hasNumber => _hasNumber;
  bool get hasLetters => _hasLetters;
  String? get errorMessage => _errorMessage;

  // Check if form is valid
  bool get isFormValid {
    return _currentPassword.isNotEmpty &&
        _newPassword.isNotEmpty &&
        _confirmPassword.isNotEmpty &&
        _hasMinLength &&
        _hasNumber &&
        _hasLetters &&
        _newPassword == _confirmPassword;
  }

  // Update current password
  void updateCurrentPassword(String password) {
    _currentPassword = password;
    _clearError();
    notifyListeners();
  }

  // Update new password and validate
  void updateNewPassword(String password) {
    _newPassword = password;
    _validateNewPassword(password);
    _clearError();
    notifyListeners();
  }

  // Update confirm password
  void updateConfirmPassword(String password) {
    _confirmPassword = password;
    _clearError();
    notifyListeners();
  }

  // Toggle password visibility
  void toggleCurrentPasswordVisibility() {
    _isCurrentPasswordVisible = !_isCurrentPasswordVisible;
    notifyListeners();
  }

  void toggleNewPasswordVisibility() {
    _isNewPasswordVisible = !_isNewPasswordVisible;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    notifyListeners();
  }

  // Validate new password requirements
  void _validateNewPassword(String password) {
    _hasMinLength = password.length >= 8;
    _hasNumber = password.contains(RegExp(r'[0-9]'));
    _hasLetters = password.contains(RegExp(r'[a-zA-Z]'));
  }

  // Set loading state
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Set error message
  void setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  // Clear error message
  void _clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  // Simulate password update API call and update UserProvider
  Future<bool> updatePassword(UserProvider userProvider) async {
    if (!isFormValid) {
      setError('Please fill all fields correctly');
      return false;
    }

    if (_newPassword != _confirmPassword) {
      setError('New passwords do not match');
      return false;
    }

    setLoading(true);

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      // Simulate API response (replace with actual API call)
      // bool success = await AuthService.updatePassword(_currentPassword, _newPassword);
      bool success = true; // Simulated success

      if (success) {
        // Update the user provider with the new password
        userProvider.updatePassword(_currentPassword, _newPassword);
        _clearError();
        return true;
      } else {
        setError('Current password is incorrect');
        return false;
      }
    } catch (e) {
      setError('Failed to update password. Please try again.');
      return false;
    } finally {
      setLoading(false);
    }
  }

  // Reset form
  void resetForm() {
    _currentPassword = '';
    _newPassword = '';
    _confirmPassword = '';
    _hasMinLength = false;
    _hasNumber = false;
    _hasLetters = false;
    _errorMessage = null;
    _isCurrentPasswordVisible = false;
    _isNewPasswordVisible = false;
    _isConfirmPasswordVisible = false;
    notifyListeners();
  }
}

// Main Update Password Screen
class UpdatePasswordScreen extends StatelessWidget {
  const UpdatePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UpdatePasswordProvider(),
      child: const _UpdatePasswordScreenContent(),
    );
  }
}

class _UpdatePasswordScreenContent extends StatelessWidget {
  const _UpdatePasswordScreenContent();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

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
      body: Consumer<UpdatePasswordProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Current Password Section
                const _SectionTitle(title: 'Your Current Password'),
                const SizedBox(height: 12),
                _PasswordField(
                  hintText: 'Current password',
                  isVisible: provider.isCurrentPasswordVisible,
                  onChanged: provider.updateCurrentPassword,
                  onToggleVisibility: provider.toggleCurrentPasswordVisibility,
                ),
                const SizedBox(height: 24),

                // New Password Section
                const _SectionTitle(title: 'Your New Password'),
                const SizedBox(height: 12),
                _PasswordField(
                  hintText: 'New password',
                  isVisible: provider.isNewPasswordVisible,
                  onChanged: provider.updateNewPassword,
                  onToggleVisibility: provider.toggleNewPasswordVisibility,
                ),
                const SizedBox(height: 24),

                // Confirm Password Section
                const _SectionTitle(title: 'Confirm New Password'),
                const SizedBox(height: 12),
                _PasswordField(
                  hintText: 'Re-enter your new password',
                  isVisible: provider.isConfirmPasswordVisible,
                  onChanged: provider.updateConfirmPassword,
                  onToggleVisibility: provider.toggleConfirmPasswordVisibility,
                ),
                const SizedBox(height: 32),

                // Password Requirements
                _PasswordRequirements(
                  hasMinLength: provider.hasMinLength,
                  hasNumber: provider.hasNumber,
                  hasLetters: provider.hasLetters,
                ),
                const SizedBox(height: 24),

                // Error Message
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

                // Update Button
                _UpdateButton(
                  isEnabled: provider.isFormValid,
                  isLoading: provider.isLoading,
                  onPressed: () => _handleUpdatePassword(context, provider, userProvider),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _handleUpdatePassword(
      BuildContext context,
      UpdatePasswordProvider provider,
      UserProvider userProvider,
      ) async {
    final success = await provider.updatePassword(userProvider);

    if (success && context.mounted) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password updated successfully!'),
          backgroundColor: Color(0xFF4CAF50),
          duration: Duration(seconds: 2),
        ),
      );

      // Navigate back using GoRouter after brief delay
      Future.delayed(const Duration(milliseconds: 500), () {
        if (context.mounted) {
          context.pop();
        }
      });
    }
  }
}

// Reusable Section Title Widget
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

// Reusable Password Field Widget
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

// Password Requirements Widget
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

// Individual Requirement Item
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

// Update Button Widget
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










// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// // Provider class for managing password update state
// class UpdatePasswordProvider extends ChangeNotifier {
//   // Private fields
//   String _currentPassword = '';
//   String _newPassword = '';
//   String _confirmPassword = '';
//   bool _isLoading = false;
//   bool _isCurrentPasswordVisible = false;
//   bool _isNewPasswordVisible = false;
//   bool _isConfirmPasswordVisible = false;
//
//   // Form validation state
//   bool _hasMinLength = false;
//   bool _hasNumber = false;
//   bool _hasLetters = false;
//   String? _errorMessage;
//
//   // Getters
//   String get currentPassword => _currentPassword;
//   String get newPassword => _newPassword;
//   String get confirmPassword => _confirmPassword;
//   bool get isLoading => _isLoading;
//   bool get isCurrentPasswordVisible => _isCurrentPasswordVisible;
//   bool get isNewPasswordVisible => _isNewPasswordVisible;
//   bool get isConfirmPasswordVisible => _isConfirmPasswordVisible;
//   bool get hasMinLength => _hasMinLength;
//   bool get hasNumber => _hasNumber;
//   bool get hasLetters => _hasLetters;
//   String? get errorMessage => _errorMessage;
//
//   // Check if form is valid
//   bool get isFormValid {
//     return _currentPassword.isNotEmpty &&
//         _newPassword.isNotEmpty &&
//         _confirmPassword.isNotEmpty &&
//         _hasMinLength &&
//         _hasNumber &&
//         _hasLetters &&
//         _newPassword == _confirmPassword;
//   }
//
//   // Update current password
//   void updateCurrentPassword(String password) {
//     _currentPassword = password;
//     _clearError();
//     notifyListeners();
//   }
//
//   // Update new password and validate
//   void updateNewPassword(String password) {
//     _newPassword = password;
//     _validateNewPassword(password);
//     _clearError();
//     notifyListeners();
//   }
//
//   // Update confirm password
//   void updateConfirmPassword(String password) {
//     _confirmPassword = password;
//     _clearError();
//     notifyListeners();
//   }
//
//   // Toggle password visibility
//   void toggleCurrentPasswordVisibility() {
//     _isCurrentPasswordVisible = !_isCurrentPasswordVisible;
//     notifyListeners();
//   }
//
//   void toggleNewPasswordVisibility() {
//     _isNewPasswordVisible = !_isNewPasswordVisible;
//     notifyListeners();
//   }
//
//   void toggleConfirmPasswordVisibility() {
//     _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
//     notifyListeners();
//   }
//
//   // Validate new password requirements
//   void _validateNewPassword(String password) {
//     _hasMinLength = password.length >= 8;
//     _hasNumber = password.contains(RegExp(r'[0-9]'));
//     _hasLetters = password.contains(RegExp(r'[a-zA-Z]'));
//   }
//
//   // Set loading state
//   void setLoading(bool loading) {
//     _isLoading = loading;
//     notifyListeners();
//   }
//
//   // Set error message
//   void setError(String error) {
//     _errorMessage = error;
//     notifyListeners();
//   }
//
//   // Clear error message
//   void _clearError() {
//     if (_errorMessage != null) {
//       _errorMessage = null;
//       notifyListeners();
//     }
//   }
//
//   // Simulate password update API call
//   Future<bool> updatePassword() async {
//     if (!isFormValid) {
//       setError('Please fill all fields correctly');
//       return false;
//     }
//
//     if (_newPassword != _confirmPassword) {
//       setError('New passwords do not match');
//       return false;
//     }
//
//     setLoading(true);
//
//     try {
//       // Simulate API call delay
//       await Future.delayed(const Duration(seconds: 2));
//
//       // Simulate API response (replace with actual API call)
//       // bool success = await AuthService.updatePassword(_currentPassword, _newPassword);
//       bool success = true; // Simulated success
//
//       if (success) {
//         _clearError();
//         return true;
//       } else {
//         setError('Current password is incorrect');
//         return false;
//       }
//     } catch (e) {
//       setError('Failed to update password. Please try again.');
//       return false;
//     } finally {
//       setLoading(false);
//     }
//   }
//
//   // Reset form
//   void resetForm() {
//     _currentPassword = '';
//     _newPassword = '';
//     _confirmPassword = '';
//     _hasMinLength = false;
//     _hasNumber = false;
//     _hasLetters = false;
//     _errorMessage = null;
//     _isCurrentPasswordVisible = false;
//     _isNewPasswordVisible = false;
//     _isConfirmPasswordVisible = false;
//     notifyListeners();
//   }
// }
//
// // Main Update Password Screen
// class UpdatePasswordScreen extends StatelessWidget {
//   const UpdatePasswordScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (context) => UpdatePasswordProvider(),
//       child: const _UpdatePasswordScreenContent(),
//     );
//   }
// }
//
// class _UpdatePasswordScreenContent extends StatelessWidget {
//   const _UpdatePasswordScreenContent();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF1A1A1A),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF1A1A1A),
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.white70),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         title: const Text(
//           'Update Password',
//           style: TextStyle(
//             color: Colors.white70,
//             fontSize: 20,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: Consumer<UpdatePasswordProvider>(
//         builder: (context, provider, child) {
//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(24.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Current Password Section
//                 const _SectionTitle(title: 'Your Current Password'),
//                 const SizedBox(height: 12),
//                 _PasswordField(
//                   hintText: 'Current password',
//                   isVisible: provider.isCurrentPasswordVisible,
//                   onChanged: provider.updateCurrentPassword,
//                   onToggleVisibility: provider.toggleCurrentPasswordVisibility,
//                 ),
//                 const SizedBox(height: 24),
//
//                 // New Password Section
//                 const _SectionTitle(title: 'Your New Password'),
//                 const SizedBox(height: 12),
//                 _PasswordField(
//                   hintText: 'New password',
//                   isVisible: provider.isNewPasswordVisible,
//                   onChanged: provider.updateNewPassword,
//                   onToggleVisibility: provider.toggleNewPasswordVisibility,
//                 ),
//                 const SizedBox(height: 24),
//
//                 // Confirm Password Section
//                 const _SectionTitle(title: 'Confirm New Password'),
//                 const SizedBox(height: 12),
//                 _PasswordField(
//                   hintText: 'Re-enter your new password',
//                   isVisible: provider.isConfirmPasswordVisible,
//                   onChanged: provider.updateConfirmPassword,
//                   onToggleVisibility: provider.toggleConfirmPasswordVisibility,
//                 ),
//                 const SizedBox(height: 32),
//
//                 // Password Requirements
//                 _PasswordRequirements(
//                   hasMinLength: provider.hasMinLength,
//                   hasNumber: provider.hasNumber,
//                   hasLetters: provider.hasLetters,
//                 ),
//                 const SizedBox(height: 24),
//
//                 // Error Message
//                 if (provider.errorMessage != null)
//                   Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.all(12),
//                     margin: const EdgeInsets.only(bottom: 24),
//                     decoration: BoxDecoration(
//                       color: Colors.red.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(8),
//                       border: Border.all(color: Colors.red.withOpacity(0.3)),
//                     ),
//                     child: Text(
//                       provider.errorMessage!,
//                       style: const TextStyle(
//                         color: Colors.red,
//                         fontSize: 14,
//                       ),
//                     ),
//                   ),
//
//                 const SizedBox(height: 32),
//
//                 // Update Button
//                 _UpdateButton(
//                   isEnabled: provider.isFormValid,
//                   isLoading: provider.isLoading,
//                   onPressed: () => _handleUpdatePassword(context, provider),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Future<void> _handleUpdatePassword(
//       BuildContext context,
//       UpdatePasswordProvider provider,
//       ) async {
//     final success = await provider.updatePassword();
//
//     if (success && context.mounted) {
//       // Show success message
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Password updated successfully!'),
//           backgroundColor: Colors.green,
//           duration: Duration(seconds: 2),
//         ),
//       );
//
//       // Navigate back after brief delay
//       Future.delayed(const Duration(milliseconds: 500), () {
//         if (context.mounted) {
//           Navigator.of(context).pop();
//         }
//       });
//     }
//   }
// }
//
// // Reusable Section Title Widget
// class _SectionTitle extends StatelessWidget {
//   final String title;
//
//   const _SectionTitle({required this.title});
//
//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       title,
//       style: const TextStyle(
//         color: Colors.white,
//         fontSize: 16,
//         fontWeight: FontWeight.w600,
//       ),
//     );
//   }
// }
//
// // Reusable Password Field Widget
// class _PasswordField extends StatelessWidget {
//   final String hintText;
//   final bool isVisible;
//   final Function(String) onChanged;
//   final VoidCallback onToggleVisibility;
//
//   const _PasswordField({
//     required this.hintText,
//     required this.isVisible,
//     required this.onChanged,
//     required this.onToggleVisibility,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: const Color(0xFF2A2A2A),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: TextField(
//         obscureText: !isVisible,
//         onChanged: onChanged,
//         style: const TextStyle(
//           color: Colors.white,
//           fontSize: 16,
//         ),
//         decoration: InputDecoration(
//           hintText: hintText,
//           hintStyle: const TextStyle(
//             color: Colors.white38,
//             fontSize: 16,
//           ),
//           prefixIcon: const Icon(
//             Icons.lock_outline,
//             color: Colors.white38,
//           ),
//           suffixIcon: IconButton(
//             icon: Icon(
//               isVisible ? Icons.visibility_off : Icons.visibility,
//               color: Colors.white38,
//             ),
//             onPressed: onToggleVisibility,
//           ),
//           border: InputBorder.none,
//           contentPadding: const EdgeInsets.symmetric(
//             horizontal: 16,
//             vertical: 16,
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // Password Requirements Widget
// class _PasswordRequirements extends StatelessWidget {
//   final bool hasMinLength;
//   final bool hasNumber;
//   final bool hasLetters;
//
//   const _PasswordRequirements({
//     required this.hasMinLength,
//     required this.hasNumber,
//     required this.hasLetters,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         _RequirementItem(
//           text: 'Minimum 8 characters',
//           isValid: hasMinLength,
//         ),
//         const SizedBox(height: 8),
//         _RequirementItem(
//           text: 'Atleast 1 number (1-9)',
//           isValid: hasNumber,
//         ),
//         const SizedBox(height: 8),
//         _RequirementItem(
//           text: 'Atleast lowercase or uppercase letters',
//           isValid: hasLetters,
//         ),
//       ],
//     );
//   }
// }
//
// // Individual Requirement Item
// class _RequirementItem extends StatelessWidget {
//   final String text;
//   final bool isValid;
//
//   const _RequirementItem({
//     required this.text,
//     required this.isValid,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Icon(
//           isValid ? Icons.check : Icons.close,
//           color: isValid ? Colors.green : Colors.red,
//           size: 20,
//         ),
//         const SizedBox(width: 12),
//         Text(
//           text,
//           style: TextStyle(
//             color: isValid ? Colors.green : Colors.red,
//             fontSize: 14,
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// // Update Button Widget
// class _UpdateButton extends StatelessWidget {
//   final bool isEnabled;
//   final bool isLoading;
//   final VoidCallback onPressed;
//
//   const _UpdateButton({
//     required this.isEnabled,
//     required this.isLoading,
//     required this.onPressed,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: double.infinity,
//       height: 56,
//       child: ElevatedButton(
//         onPressed: isEnabled && !isLoading ? onPressed : null,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: const Color(0xFF00C853),
//           disabledBackgroundColor: Colors.grey.withOpacity(0.3),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           elevation: 0,
//         ),
//         child: isLoading
//             ? const SizedBox(
//           height: 24,
//           width: 24,
//           child: CircularProgressIndicator(
//             color: Colors.white,
//             strokeWidth: 2,
//           ),
//         )
//             : const Text(
//           'Update Password',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 16,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),
//     );
//   }
// }