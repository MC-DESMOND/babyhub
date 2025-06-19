import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:babyhub/router/app_router.dart'; // this is where your GoRouter config lives

void main() {
  runApp(
    const ProviderScope(child: BabyHubApp()),
  );
}

class BabyHubApp extends StatelessWidget {
  const BabyHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router, // use the router from app_router.dart
      title: 'BabyHub Store',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.amber,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }
}
