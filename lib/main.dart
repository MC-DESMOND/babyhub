import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import './admin/edt_prod.dart';
import './admin/all_orders.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  final GoRouter _router = GoRouter(
    initialLocation: '/edit-product',
    routes: [
      GoRoute(
        path: '/edit-product',
        builder: (context, state) => const EditProductPage(),
      ),
      GoRoute(
        path: '/all-orders',
        builder: (context, state) => const OrdersPage(),
      ),
    ],
  );

  App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp.router(
      title: 'Baby Shop Hub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, brightness: Brightness.dark),
      routerDelegate: _router.routerDelegate,
      routeInformationParser: _router.routeInformationParser,
      routeInformationProvider: _router.routeInformationProvider,
    );
  }
}


// RichText(
//                 text: const TextSpan(
//                   children: [
//                     TextSpan(
//                       text: '1 ',
//                       style: TextStyle(
//                         color: Color(0xFF4A9EFF),
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     TextSpan(
//                       text: '- 8 of 13 Pages',
//                       style: TextStyle(
//                         color: Colors.white70,
//                         fontSize: 14,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Row(
//                 children: [
//                   Icon(Icons.arrow_back_ios_new, color: Colors.white70, size: 16),
//                   SizedBox(width: 8),
//                   Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 16),
//                 ],
//               ),