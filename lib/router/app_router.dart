import 'package:go_router/go_router.dart';
import 'package:babyhub/features/products/product_list_screen.dart';
import 'package:babyhub/features/cart/cart_screen.dart';
import 'package:babyhub/features/checkout/checkout_screen.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/history',
      builder: (context, state) => const ProductHistoryScreen(),
    ),
    GoRoute(
      path: '/cart',
      name: 'cart',
      builder: (context, state) => const CartScreen(),
    ),
    GoRoute(
      path: '/checkout',
      name: 'checkout',
      builder: (context, state) => const CheckoutScreen(),
    ),
    // You can define other routes here like:
    // GoRoute(path: '/product/:id', ...)
  ],
);
