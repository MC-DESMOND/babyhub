import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:go_router/go_router.dart';

// Providers
import 'package:babyshophub1/providers/user_provider.dart';
import 'package:babyshophub1/providers/delivery_provider.dart';
import 'package:babyshophub1/providers/payment_provider.dart';

// Router
import 'app_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => DeliveryProvider()),
        ChangeNotifierProvider(create: (_) => PaymentProvider()),
      ],
      child: MaterialApp.router(
        title: 'Profile App',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: const Color(0xFF1A1A1A),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1A1A1A),
            elevation: 0,
          ),
        ),
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}










// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:go_router/go_router.dart';
//
// // Import providers
// import 'lib/providers/user_provider.dart';
// import 'lib/providers/delivery_provider.dart';
// import 'lib/providers/payment_provider.dart';
//
// // Import router
// import 'lib/app_router.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (context) => UserProvider()),
//         ChangeNotifierProvider(create: (context) => DeliveryProvider()),
//         ChangeNotifierProvider(create: (context) => PaymentProvider()),
//       ],
//       child: MaterialApp.router(
//         title: 'Profile App',
//         theme: ThemeData.dark().copyWith(
//           scaffoldBackgroundColor: const Color(0xFF1A1A1A),
//           appBarTheme: const AppBarTheme(
//             backgroundColor: Color(0xFF1A1A1A),
//             elevation: 0,
//           ),
//         ),
//         routerConfig: AppRouter.router,
//         debugShowCheckedModeBanner: false,
//       ),
//     );
//   }
// }
//
// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.white70),
//           onPressed: () => context.canPop() ? context.pop() : null,
//         ),
//         title: const Row(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             Text(
//               'Profile',
//               style: TextStyle(
//                 color: Colors.white70,
//                 fontSize: 28,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ],
//         ),
//         centerTitle: false,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: Consumer3<UserProvider, DeliveryProvider, PaymentProvider>(
//               builder: (context, userProvider, deliveryProvider, paymentProvider, child) {
//                 if (userProvider.isLoading || deliveryProvider.isLoading || paymentProvider.isLoading) {
//                   return const Center(
//                     child: CircularProgressIndicator(color: Colors.white),
//                   );
//                 }
//
//                 return ListView(
//                   padding: const EdgeInsets.all(20.0),
//                   children: [
//                     _buildMenuItem(
//                       title: 'Personal Information',
//                       subtitle: 'Edit your account information',
//                       trailing: userProvider.user.name,
//                       onTap: () => context.pushNamed('personal-information'),
//                     ),
//                     _buildMenuItem(
//                       title: 'Update Your Password',
//                       subtitle: 'Set a new account password',
//                       onTap: () => context.pushNamed('update-password'),
//                     ),
//                     _buildMenuItem(
//                       title: 'Delivery Information',
//                       subtitle: 'Manage your delivery addresses',
//                       trailing: '${deliveryProvider.addresses.length} addresses',
//                       onTap: () => context.pushNamed('delivery-information'),
//                     ),
//                     _buildMenuItem(
//                       title: 'Payment Methods',
//                       subtitle: 'Manage your payment methods',
//                       trailing: '${paymentProvider.paymentMethods.length} methods',
//                       onTap: () => context.pushNamed('payment-methods'),
//                     ),
//                   ],
//                 );
//               },
//             ),
//           ),
//           _buildBottomNavigation(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildMenuItem({
//     required String title,
//     required String subtitle,
//     String? trailing,
//     required VoidCallback onTap,
//   }) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 1.0),
//       child: ListTile(
//         contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
//         title: Text(
//           title,
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 19,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(top: 1.0),
//               child: Text(
//                 subtitle,
//                 style: const TextStyle(
//                   color: Colors.white60,
//                   fontSize: 16,
//                 ),
//               ),
//             ),
//             if (trailing != null)
//               Padding(
//                 padding: const EdgeInsets.only(top: 2.0),
//                 child: Text(
//                   trailing,
//                   style: const TextStyle(
//                     color: Colors.white70,
//                     fontSize: 12,
//                   ),
//                 ),
//               ),
//           ],
//         ),
//         trailing: const Icon(
//           Icons.arrow_forward_ios,
//           color: Colors.white60,
//           size: 16,
//         ),
//         onTap: onTap,
//       ),
//     );
//   }
//
//   Widget _buildBottomNavigation() {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 16),
//       decoration: const BoxDecoration(
//         color: Color(0xFF1A1A1A),
//         border: Border(
//           top: BorderSide(color: Colors.white12, width: 0.5),
//         ),
//       ),
//       child: Consumer<UserProvider>(
//         builder: (context, userProvider, child) {
//           // You can add navigation state to UserProvider if needed
//           // For now, keeping it simple with local state
//           return Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               _buildNavItem(Icons.home_outlined, 'HOME', false, () {}),
//               _buildNavItem(Icons.favorite_border, 'WISHLIST', false, () {}),
//               _buildNavItem(Icons.shopping_cart_outlined, 'CART', false, () {}),
//               _buildNavItem(Icons.person_outline, 'LOGIN', true, () {}),
//             ],
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildNavItem(IconData icon, String label, bool isSelected, VoidCallback onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(
//             icon,
//             color: isSelected ? Colors.white : Colors.white60,
//             size: 25,
//           ),
//           const SizedBox(height: 4),
//           Text(
//             label,
//             style: TextStyle(
//               color: isSelected ? Colors.white : Colors.white60,
//               fontSize: 13,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }










// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'personal_information_screen.dart';
// import 'update_password_screen.dart';
// import 'delivery_information_screen.dart';
// import 'payment_methods_screen.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// // Step 1: Create a data model for user profile
// class UserProfile {
//   final String name;
//   final String email;
//   final String phone;
//   final List<String> addresses;
//   final List<String> paymentMethods;
//
//   UserProfile({
//     required this.name,
//     required this.email,
//     required this.phone,
//     required this.addresses,
//     required this.paymentMethods,
//   });
// }
//
// // Step 2: Create a Provider class to manage profile state
// class ProfileProvider extends ChangeNotifier {
//   UserProfile _userProfile = UserProfile(
//     name: 'John Doe',
//     email: 'john.doe@example.com',
//     phone: '+1 234 567 8900',
//     addresses: ['123 Main St, City, State', '456 Oak Ave, City, State'],
//     paymentMethods: ['**** 1234', '**** 5678'],
//   );
//
//   int _selectedNavIndex = 3; // LOGIN tab selected by default
//   bool _isLoading = false;
//
//   // Getters to access private data
//   UserProfile get userProfile => _userProfile;
//   int get selectedNavIndex => _selectedNavIndex;
//   bool get isLoading => _isLoading;
//
//   // Methods to update state
//   void updateProfile(UserProfile newProfile) {
//     _userProfile = newProfile;
//     notifyListeners(); // This tells widgets to rebuild
//   }
//
//   void setSelectedNavIndex(int index) {
//     _selectedNavIndex = index;
//     notifyListeners();
//   }
//
//   void setLoading(bool loading) {
//     _isLoading = loading;
//     notifyListeners();
//   }
//
//   void addAddress(String address) {
//     _userProfile = UserProfile(
//       name: _userProfile.name,
//       email: _userProfile.email,
//       phone: _userProfile.phone,
//       addresses: [..._userProfile.addresses, address],
//       paymentMethods: _userProfile.paymentMethods,
//     );
//     notifyListeners();
//   }
//
//   void removeAddress(int index) {
//     List<String> newAddresses = List.from(_userProfile.addresses);
//     newAddresses.removeAt(index);
//     _userProfile = UserProfile(
//       name: _userProfile.name,
//       email: _userProfile.email,
//       phone: _userProfile.phone,
//       addresses: newAddresses,
//       paymentMethods: _userProfile.paymentMethods,
//     );
//     notifyListeners();
//   }
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     // Step 3: Wrap your app with ChangeNotifierProvider
//     return ChangeNotifierProvider(
//       create: (context) => ProfileProvider(),
//       child: MaterialApp(
//         title: 'Profile App',
//         theme: ThemeData.dark().copyWith(
//           scaffoldBackgroundColor: const Color(0xFF1A1A1A),
//           appBarTheme: const AppBarTheme(
//             backgroundColor: Color(0xFF1A1A1A),
//             elevation: 0,
//           ),
//         ),
//         home: const ProfileScreen(),
//         debugShowCheckedModeBanner: false,
//       ),
//     );
//   }
// }
//
// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.white70),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         title: const Row(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             Text(
//               'Profile',
//               style: TextStyle(
//                 color: Colors.white70,
//                 fontSize: 28,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ],
//         ),
//         centerTitle: false,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: Consumer<ProfileProvider>(
//               builder: (context, profileProvider, child) {
//                 // Step 4: Use Consumer to listen to state changes
//                 if (profileProvider.isLoading) {
//                   return const Center(
//                     child: CircularProgressIndicator(color: Colors.white),
//                   );
//                 }
//
//                 return ListView(
//                   padding: const EdgeInsets.all(20.0),
//                   children: [
//                     _buildMenuItem(
//                       title: 'Personal Information',
//                       subtitle: 'Edit your account information',
//                       trailing: profileProvider.userProfile.name,
//                       onTap: () => _handleMenuTap(context, 'Personal Information'),
//                     ),
//                     _buildMenuItem(
//                       title: 'Update Your Password',
//                       subtitle: 'Set a new account password',
//                       onTap: () => _handleMenuTap(context, 'Update Password'),
//                     ),
//                     _buildMenuItem(
//                       title: 'Delivery Information',
//                       subtitle: 'Manage your delivery addresses',
//                       trailing: '${profileProvider.userProfile.addresses.length} addresses',
//                       onTap: () => _handleMenuTap(context, 'Delivery Information'),
//                     ),
//                     _buildMenuItem(
//                       title: 'Payment Methods',
//                       subtitle: 'Manage your payment methods',
//                       trailing: '${profileProvider.userProfile.paymentMethods.length} methods',
//                       onTap: () => _handleMenuTap(context, 'Payment Methods'),
//                     ),
//                   ],
//                 );
//               },
//             ),
//           ),
//           _buildBottomNavigation(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildMenuItem({
//     required String title,
//     required String subtitle,
//     String? trailing,
//     required VoidCallback onTap,
//   }) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 1.0),
//       child: ListTile(
//         contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
//         title: Text(
//           title,
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 19,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(top: 1.0),
//               child: Text(
//                 subtitle,
//                 style: const TextStyle(
//                   color: Colors.white60,
//                   fontSize: 16,
//                 ),
//               ),
//             ),
//             if (trailing != null)
//               Padding(
//                 padding: const EdgeInsets.only(top: 2.0),
//                 child: Text(
//                   trailing,
//                   style: const TextStyle(
//                     color: Colors.white70,
//                     fontSize: 12,
//                   ),
//                 ),
//               ),
//           ],
//         ),
//         trailing: const Icon(
//           Icons.arrow_forward_ios,
//           color: Colors.white60,
//           size: 16,
//         ),
//         onTap: onTap,
//       ),
//     );
//   }
//
//   Widget _buildBottomNavigation() {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 16),
//       decoration: const BoxDecoration(
//         color: Color(0xFF1A1A1A),
//         border: Border(
//           top: BorderSide(color: Colors.white12, width: 0.5),
//         ),
//       ),
//       child: Consumer<ProfileProvider>(
//         builder: (context, profileProvider, child) {
//           return Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               _buildNavItem(
//                 Icons.home_outlined,
//                 'HOME',
//                 profileProvider.selectedNavIndex == 0,
//                     () => profileProvider.setSelectedNavIndex(0),
//               ),
//               _buildNavItem(
//                 Icons.favorite_border,
//                 'WISHLIST',
//                 profileProvider.selectedNavIndex == 1,
//                     () => profileProvider.setSelectedNavIndex(1),
//               ),
//               _buildNavItem(
//                 Icons.shopping_cart_outlined,
//                 'CART',
//                 profileProvider.selectedNavIndex == 2,
//                     () => profileProvider.setSelectedNavIndex(2),
//               ),
//               _buildNavItem(
//                 Icons.person_outline,
//                 'LOGIN',
//                 profileProvider.selectedNavIndex == 3,
//                     () => profileProvider.setSelectedNavIndex(3),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildNavItem(IconData icon, String label, bool isSelected, VoidCallback onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(
//             icon,
//             color: isSelected ? Colors.white : Colors.white60,
//             size: 25,
//           ),
//           const SizedBox(height: 4),
//           Text(
//             label,
//             style: TextStyle(
//               color: isSelected ? Colors.white : Colors.white60,
//               fontSize: 13,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // UPDATED METHOD - Now correctly placed outside the build method
//   // UPDATED METHOD - Now handles navigation to multiple screens
//   void _handleMenuTap(BuildContext context, String menuItem) {
//     final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
//
//     if (menuItem == 'Personal Information') {
//       // Navigate to Personal Information screen
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => const PersonalInformationScreen(),
//         ),
//       );
//     } else if (menuItem == 'Update Password') {
//       // Navigate to Update Password screen
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => const UpdatePasswordScreen(),
//         ),
//       );
//     }
//     // Uncomment these sections when you create the respective screens
//
//     else if (menuItem == 'Delivery Information') {
//       // Navigate to Delivery Information screen
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => const DeliveryInformationScreen(),
//         ),
//       );
//     } else if (menuItem == 'Payment Methods') {
//       // Navigate to Payment Methods screen
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => const PaymentMethodsScreen(),
//         ),
//       );
//     }
//
//     else {
//       // For other menu items, show loading and snack bar as before
//       profileProvider.setLoading(true);
//       Future.delayed(const Duration(seconds: 1), () {
//         profileProvider.setLoading(false);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('$menuItem loaded'),
//             backgroundColor: Colors.white24,
//             duration: const Duration(seconds: 1),
//           ),
//         );
//       });
//     }
//   }
// }
//
// // Example of how to use Provider in another screen
// class PersonalInfoScreen extends StatelessWidget {
//   const PersonalInfoScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Personal Information'),
//       ),
//       body: Consumer<ProfileProvider>(
//         builder: (context, profileProvider, child) {
//           final user = profileProvider.userProfile;
//
//           return Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Name: ${user.name}',
//                   style: const TextStyle(color: Colors.white, fontSize: 18),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   'Email: ${user.email}',
//                   style: const TextStyle(color: Colors.white, fontSize: 18),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   'Phone: ${user.phone}',
//                   style: const TextStyle(color: Colors.white, fontSize: 18),
//                 ),
//                 const SizedBox(height: 16),
//                 ElevatedButton(
//                   onPressed: () {
//                     // Example of updating state
//                     profileProvider.updateProfile(
//                       UserProfile(
//                         name: 'Updated Name',
//                         email: user.email,
//                         phone: user.phone,
//                         addresses: user.addresses,
//                         paymentMethods: user.paymentMethods,
//                       ),
//                     );
//                   },
//                   child: const Text('Update Name'),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }