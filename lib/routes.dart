import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'main.dart';
import 'product_search.dart';
import 'product.dart';
import 'details.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/profile_screen.dart'; // New import

class AppRoutes {
  static const String homePath = '/';
  static const String homeRouteName = 'home';
  static const String searchPath = '/search';
  static const String searchRouteName = 'search';
  static const String productsPath = '/products';
  static const String productsRouteName = 'products';
  static const String detailsPath = '/details';
  static const String detailsRouteName = 'details';
  static const String loginPath = '/login';
  static const String loginRouteName = 'login';
  static const String signupPath = '/signup';
  static const String signupRouteName = 'signup';
  static const String cartPath = '/cart';
  static const String cartRouteName = 'cart';
  static const String profilePath = '/profile'; // New path
  static const String profileRouteName = 'profile'; // New route name
}

// Go Router Configuration
final GoRouter router = GoRouter(
  initialLocation: AppRoutes.homePath,
  routes: [
    // Home Route
    GoRoute(
      path: AppRoutes.homePath,
      name: AppRoutes.homeRouteName,
      builder: (context, state) => const HomePage(),
    ),

    // Search Route
    GoRoute(
      path: AppRoutes.searchPath,
      name: AppRoutes.searchRouteName,
      builder: (context, state) {
        // Extract parameters from extra data
        final Map<String, dynamic>? extra = state.extra as Map<String, dynamic>?;
        final List<Map<String, dynamic>> allProducts = extra?['allProducts'] ?? [];
        final String? initialCategory = extra?['initialCategory'];

        return SearchProductPage(
          allProducts: allProducts,
          initialCategory: initialCategory,
        );
      },
    ),

    // Products Route
    GoRoute(
      path: AppRoutes.productsPath,
      name: AppRoutes.productsRouteName,
      builder: (context, state) {
        // Extract parameters from extra data
        final Map<String, dynamic>? extra = state.extra as Map<String, dynamic>?;
        final List<Map<String, dynamic>> products = extra?['products'] ?? [];
        final String? searchQuery = extra?['searchQuery'];

        return ProductPage(
          products: products,
          searchQuery: searchQuery,
        );
      },
    ),

    // Details Route
    GoRoute(
      path: AppRoutes.detailsPath,
      name: AppRoutes.detailsRouteName,
      builder: (context, state) {
        // Extract product data from extra
        final Map<String, dynamic>? extra = state.extra as Map<String, dynamic>?;
        final Map<String, dynamic> product = extra?['product'] ?? {};

        return DetailsPage(product: product);
      },
    ),

    // Login Route
    GoRoute(
      path: AppRoutes.loginPath,
      name: AppRoutes.loginRouteName,
      builder: (context, state) => const LoginScreen(),
    ),

    // Signup Route
    GoRoute(
      path: AppRoutes.signupPath,
      name: AppRoutes.signupRouteName,
      builder: (context, state) => const SignupScreen(),
    ),

    // Cart Route
    GoRoute(
      path: AppRoutes.cartPath,
      name: AppRoutes.cartRouteName,
      builder: (context, state) => const CartScreen(),
    ),

    // Profile Route (New)
    GoRoute(
      path: AppRoutes.profilePath,
      name: AppRoutes.profileRouteName,
      builder: (context, state) => const ProfileScreen(),
    ),
  ],

  // Error handling
  errorBuilder: (context, state) => Scaffold(
    backgroundColor: const Color(0xFF1A1A1A),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.white54,
            size: 64,
          ),
          const SizedBox(height: 16),
          const Text(
            'Page Not Found',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'The page "${state.uri}" could not be found.',
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => NavigationHelper.goHome(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00C896),
              foregroundColor: Colors.white,
            ),
            child: const Text('Go Home'),
          ),
        ],
      ),
    ),
  ),
);

// Navigation Helper Class
class NavigationHelper {
  // Navigate to search page
  static void goToSearch(
    BuildContext context, {
    required List<Map<String, dynamic>> allProducts,
    String? initialCategory,
  }) {
    context.pushNamed(
      AppRoutes.searchRouteName,
      extra: {
        'allProducts': allProducts,
        'initialCategory': initialCategory,
      },
    );
  }

  // Navigate to products page
  static void goToProducts(
    BuildContext context, {
    required List<Map<String, dynamic>> products,
    String? searchQuery,
  }) {
    context.pushNamed(
      AppRoutes.productsRouteName,
      extra: {
        'products': products,
        'searchQuery': searchQuery,
      },
    );
  }

  // Navigate to details page
  static void goToDetails(
    BuildContext context, {
    required Map<String, dynamic> product,
  }) {
    context.pushNamed(
      AppRoutes.detailsRouteName,
      extra: {
        'product': product,
      },
    );
  }

  // Navigate to login page
  static void goToLogin(BuildContext context) {
    context.pushNamed(AppRoutes.loginRouteName);
  }

  // Navigate to signup page
  static void goToSignup(BuildContext context) {
    context.pushNamed(AppRoutes.signupRouteName);
  }

  // Navigate to cart page (go as it's a main tab)
  static void goToCart(BuildContext context) {
    context.goNamed(AppRoutes.cartRouteName);
  }

  // Navigate to profile page (go as it's a main tab)
  static void goToProfile(BuildContext context) {
    context.goNamed(AppRoutes.profileRouteName);
  }

  // Navigate back
  static void goBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.homePath);
    }
  }

  // Navigate to home
  static void goHome(BuildContext context) {
    context.go(AppRoutes.homePath);
  }
}
