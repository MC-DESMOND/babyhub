// lib/routes/app_router.dart
import 'package:go_router/go_router.dart';
import '../screens/orders_screen.dart';
import '../screens/dashboard_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/orders',
    routes: [
      GoRoute(
        path: '/orders',
        builder: (context, state) => OrdersScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => DashboardScreen(),
      ),
    ],
  );
}