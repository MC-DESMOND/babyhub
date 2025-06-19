import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'main.dart';
import 'product_search.dart';
import 'product.dart';
import 'details.dart';

class AppRoutes {
  static const String home = '/';
  static const String search = '/search';
  static const String products = '/products';
  static const String details = '/details';
}

// Go Router Configuration
final GoRouter router = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    // Home Route
    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      builder: (context, state) => const HomePage(),
    ),

    // Search Route
    GoRoute(
      path: AppRoutes.search,
      name: 'search',
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
      path: AppRoutes.products,
      name: 'products',
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
      path: AppRoutes.details,
      name: 'details',
      builder: (context, state) {
        // Extract product data from extra
        final Map<String, dynamic>? extra = state.extra as Map<String, dynamic>?;
        final Map<String, dynamic> product = extra?['product'] ?? {};

        return DetailsPage(product: product);
      },
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
            onPressed: () => context.go(AppRoutes.home),
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
      'search',
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
      'products',
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
      'details',
      extra: {
        'product': product,
      },
    );
  }

  // Navigate back
  static void goBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.home);
    }
  }

  // Navigate to home
  static void goHome(BuildContext context) {
    context.go(AppRoutes.home);
  }
}