import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/user_provider.dart';

class PersonalInformationScreen extends StatefulWidget {
  const PersonalInformationScreen({super.key});

  @override
  State<PersonalInformationScreen> createState() => _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _dateOfBirthController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with current user data
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.user;

    // Split the name into first and last name
    List<String> nameParts = user.name.split(' ');
    String firstName = nameParts.isNotEmpty ? nameParts[0] : '';
    String lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

    _firstNameController = TextEditingController(text: firstName);
    _lastNameController = TextEditingController(text: lastName);
    _emailController = TextEditingController(text: user.email);
    _dateOfBirthController = TextEditingController(text: '03/04/1990');
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _dateOfBirthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          'Personal Information',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    _buildFormField(
                      label: 'First name',
                      controller: _firstNameController,
                      icon: Icons.person_outline,
                    ),
                    const SizedBox(height: 24),
                    _buildFormField(
                      label: 'Last name',
                      controller: _lastNameController,
                      icon: Icons.person_outline,
                    ),
                    const SizedBox(height: 24),
                    _buildFormField(
                      label: 'Email address',
                      controller: _emailController,
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 24),
                    _buildFormField(
                      label: 'Date of birth',
                      controller: _dateOfBirthController,
                      icon: Icons.calendar_today_outlined,
                      readOnly: true,
                      onTap: () => _selectDate(context),
                    ),
                  ],
                ),
              ),
            ),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType? keyboardType,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF2D2D2D),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            readOnly: readOnly,
            onTap: onTap,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(
                icon,
                color: Colors.white60,
                size: 20,
              ),
              suffixIcon: const Icon(
                Icons.edit,
                color: Colors.white60,
                size: 18,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFF4CAF50),
                  width: 1,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              filled: true,
              fillColor: const Color(0xFF2D2D2D),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required';
              }
              if (label == 'Email address') {
                if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                  return 'Please enter a valid email address';
                }
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(24.0),
      child: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          return ElevatedButton(
            onPressed: userProvider.isLoading ? null : () => _handleSubmit(userProvider),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              elevation: 0,
            ),
            child: userProvider.isLoading
                ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
                : const Text(
              'Submit',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    // Parse current date
    List<String> dateParts = _dateOfBirthController.text.split('/');
    DateTime initialDate = DateTime.now();

    if (dateParts.length == 3) {
      try {
        initialDate = DateTime(
          int.parse(dateParts[2]), // year
          int.parse(dateParts[1]), // month
          int.parse(dateParts[0]), // day
        );
      } catch (e) {
        initialDate = DateTime(1990, 4, 3);
      }
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF4CAF50),
              onPrimary: Colors.white,
              surface: Color(0xFF2D2D2D),
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: const Color(0xFF1A1A1A),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _dateOfBirthController.text =
        '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      });
    }
  }

  void _handleSubmit(UserProvider userProvider) {
    if (_formKey.currentState!.validate()) {
      userProvider.setLoading(true);

      // Simulate API call
      Future.delayed(const Duration(seconds: 2), () {
        // Update user profile with new data
        userProvider.updatePersonalInfo(
          name: '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}',
          email: _emailController.text.trim(),
          phone: userProvider.user.phone, // Keep existing phone
        );

        userProvider.setLoading(false);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Personal information updated successfully!'),
            backgroundColor: Color(0xFF4CAF50),
            duration: Duration(seconds: 2),
          ),
        );

        // Navigate back using GoRouter
        context.pop();
      });
    }
  }
}










// import 'main.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
//
// class PersonalInformationScreen extends StatefulWidget {
//   const PersonalInformationScreen({super.key});
//
//   @override
//   State<PersonalInformationScreen> createState() => _PersonalInformationScreenState();
// }
//
// class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
//   final _formKey = GlobalKey<FormState>();
//   late TextEditingController _firstNameController;
//   late TextEditingController _lastNameController;
//   late TextEditingController _emailController;
//   late TextEditingController _dateOfBirthController;
//
//   @override
//   void initState() {
//     super.initState();
//     // Initialize controllers with current user data
//     final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
//     final user = profileProvider.userProfile;
//
//     // Split the name into first and last name
//     List<String> nameParts = user.name.split(' ');
//     String firstName = nameParts.isNotEmpty ? nameParts[0] : '';
//     String lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
//
//     _firstNameController = TextEditingController(text: firstName);
//     _lastNameController = TextEditingController(text: lastName);
//     _emailController = TextEditingController(text: user.email);
//     _dateOfBirthController = TextEditingController(text: '03/04/1990');
//   }
//
//   @override
//   void dispose() {
//     _firstNameController.dispose();
//     _lastNameController.dispose();
//     _emailController.dispose();
//     _dateOfBirthController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF1A1A1A),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF1A1A1A),
//         elevation: 0,
//         leading: Container(
//           margin: const EdgeInsets.all(8.0),
//           decoration: BoxDecoration(
//             color: const Color(0xFF2D2D2D),
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: IconButton(
//             icon: const Icon(Icons.arrow_back_ios, color: Colors.white70, size: 18),
//             onPressed: () => Navigator.of(context).pop(),
//           ),
//         ),
//         title: const Text(
//           'Personal Information',
//           style: TextStyle(
//             color: Colors.white70,
//             fontSize: 20,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: Form(
//         key: _formKey,
//         child: Column(
//           children: [
//             Expanded(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.all(24.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const SizedBox(height: 20),
//                     _buildFormField(
//                       label: 'First name',
//                       controller: _firstNameController,
//                       icon: Icons.person_outline,
//                     ),
//                     const SizedBox(height: 24),
//                     _buildFormField(
//                       label: 'Last name',
//                       controller: _lastNameController,
//                       icon: Icons.person_outline,
//                     ),
//                     const SizedBox(height: 24),
//                     _buildFormField(
//                       label: 'Email address',
//                       controller: _emailController,
//                       icon: Icons.email_outlined,
//                       keyboardType: TextInputType.emailAddress,
//                     ),
//                     const SizedBox(height: 24),
//                     _buildFormField(
//                       label: 'Date of birth',
//                       controller: _dateOfBirthController,
//                       icon: Icons.calendar_today_outlined,
//                       readOnly: true,
//                       onTap: () => _selectDate(context),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             _buildSubmitButton(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildFormField({
//     required String label,
//     required TextEditingController controller,
//     required IconData icon,
//     TextInputType? keyboardType,
//     bool readOnly = false,
//     VoidCallback? onTap,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 18,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Container(
//           decoration: BoxDecoration(
//             color: const Color(0xFF2D2D2D),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: TextFormField(
//             controller: controller,
//             keyboardType: keyboardType,
//             readOnly: readOnly,
//             onTap: onTap,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 17,
//             ),
//             decoration: InputDecoration(
//               prefixIcon: Icon(
//                 icon,
//                 color: Colors.white60,
//                 size: 20,
//               ),
//               suffixIcon: const Icon(
//                 Icons.edit,
//                 color: Colors.white60,
//                 size: 18,
//               ),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: BorderSide.none,
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: const BorderSide(
//                   color: Color(0xFF4CAF50),
//                   width: 1,
//                 ),
//               ),
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 16,
//                 vertical: 16,
//               ),
//               filled: true,
//               fillColor: const Color(0xFF2D2D2D),
//             ),
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'This field is required';
//               }
//               if (label == 'Email address') {
//                 if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
//                   return 'Please enter a valid email address';
//                 }
//               }
//               return null;
//             },
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildSubmitButton() {
//     return Container(
//       width: double.infinity,
//       margin: const EdgeInsets.all(24.0),
//       child: Consumer<ProfileProvider>(
//         builder: (context, profileProvider, child) {
//           return ElevatedButton(
//             onPressed: profileProvider.isLoading ? null : () => _handleSubmit(profileProvider),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFF4CAF50),
//               foregroundColor: Colors.white,
//               padding: const EdgeInsets.symmetric(vertical: 16),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(25),
//               ),
//               elevation: 0,
//             ),
//             child: profileProvider.isLoading
//                 ? const SizedBox(
//               height: 20,
//               width: 20,
//               child: CircularProgressIndicator(
//                 color: Colors.white,
//                 strokeWidth: 2,
//               ),
//             )
//                 : const Text(
//               'Submit',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Future<void> _selectDate(BuildContext context) async {
//     // Parse current date
//     List<String> dateParts = _dateOfBirthController.text.split('/');
//     DateTime initialDate = DateTime.now();
//
//     if (dateParts.length == 3) {
//       try {
//         initialDate = DateTime(
//           int.parse(dateParts[2]), // year
//           int.parse(dateParts[1]), // month
//           int.parse(dateParts[0]), // day
//         );
//       } catch (e) {
//         initialDate = DateTime(1990, 4, 3);
//       }
//     }
//
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: initialDate,
//       firstDate: DateTime(1900),
//       lastDate: DateTime.now(),
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: const ColorScheme.dark(
//               primary: Color(0xFF4CAF50),
//               onPrimary: Colors.white,
//               surface: Color(0xFF2D2D2D),
//               onSurface: Colors.white,
//             ),
//             dialogBackgroundColor: const Color(0xFF1A1A1A),
//           ),
//           child: child!,
//         );
//       },
//     );
//
//     if (picked != null) {
//       setState(() {
//         _dateOfBirthController.text =
//         '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
//       });
//     }
//   }
//
//   void _handleSubmit(ProfileProvider profileProvider) {
//     if (_formKey.currentState!.validate()) {
//       profileProvider.setLoading(true);
//
//       // Simulate API call
//       Future.delayed(const Duration(seconds: 2), () {
//         // Update user profile with new data
//         final updatedProfile = UserProfile(
//           name: '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}',
//           email: _emailController.text.trim(),
//           phone: profileProvider.userProfile.phone, // Keep existing phone
//           addresses: profileProvider.userProfile.addresses,
//           paymentMethods: profileProvider.userProfile.paymentMethods,
//         );
//
//         profileProvider.updateProfile(updatedProfile);
//         profileProvider.setLoading(false);
//
//         // Show success message
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Personal information updated successfully!'),
//             backgroundColor: Color(0xFF4CAF50),
//             duration: Duration(seconds: 2),
//           ),
//         );
//
//         // Navigate back to profile screen
//         Navigator.of(context).pop();
//       });
//     }
//   }
// }