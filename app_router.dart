import 'package:go_router/go_router.dart';
import 'package:babyshophub1/screens/profile_screen.dart';
import 'package:babyshophub1/screens/personal_information_screen.dart';
import 'package:babyshophub1/screens/update_password_screen.dart';
import 'package:babyshophub1/screens/delivery_information_screen.dart';
import 'package:babyshophub1/screens/payment_methods_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/profile',
    routes: [
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/personal-information',
        name: 'personal-information',
        builder: (context, state) => const PersonalInformationScreen(),
      ),
      GoRoute(
        path: '/update-password',
        name: 'update-password',
        builder: (context, state) => const UpdatePasswordScreen(),
      ),
      GoRoute(
        path: '/delivery-information',
        name: 'delivery-information',
        builder: (context, state) => const DeliveryInformationScreen(),
      ),
      GoRoute(
        path: '/payment-methods',
        name: 'payment-methods',
        builder: (context, state) => const PaymentMethodsScreen(),
      ),
    ],
  );
}









// import 'package:go_router/go_router.dart';
// import 'package:babyshophub1/screens/personal_information_screen.dart';
// import 'package:babyshophub1/screens/update_password_screen.dart';
// import 'package:babyshophub1/screens/delivery_information_screen.dart';
// import 'package:babyshophub1/screens/payment_methods_screen.dart';
//
// // Profile Screen - extracted from main.dart
// import 'package:babyshophub1/screens/main.dart' show ProfileScreen;
//
// class AppRouter {
//   static final GoRouter router = GoRouter(
//     initialLocation: '/profile',
//     routes: [
//       GoRoute(
//         path: '/profile',
//         name: 'profile',
//         builder: (context, state) => const ProfileScreen(),
//       ),
//       GoRoute(
//         path: '/personal-information',
//         name: 'personal-information',
//         builder: (context, state) => const PersonalInformationScreen(),
//       ),
//       GoRoute(
//         path: '/update-password',
//         name: 'update-password',
//         builder: (context, state) => const UpdatePasswordScreen(),
//       ),
//       GoRoute(
//         path: '/delivery-information',
//         name: 'delivery-information',
//         builder: (context, state) => const DeliveryInformationScreen(),
//       ),
//       GoRoute(
//         path: '/payment-methods',
//         name: 'payment-methods',
//         builder: (context, state) => const PaymentMethodsScreen(),
//       ),
//     ],
//   );
// }