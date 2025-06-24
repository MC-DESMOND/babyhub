import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../routes.dart';

class AppBottomNavigationBar extends StatelessWidget {
  final bool isLoggedIn;

  const AppBottomNavigationBar({
    super.key,
    required this.isLoggedIn,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> navItems = [
      {"icon": Icons.home, "label": "HOME", "path": AppRoutes.homePath, "routeName": AppRoutes.homeRouteName},
      {"icon": Icons.favorite_border, "label": "WISHLIST", "path": null, "routeName": null},
      {"icon": Icons.shopping_bag_outlined, "label": "CART", "path": AppRoutes.cartPath, "routeName": AppRoutes.cartRouteName},
      {
        "icon": isLoggedIn ? Icons.person_outline : Icons.login,
        "label": isLoggedIn ? "PROFILE" : "LOGIN",
        "path": isLoggedIn ? AppRoutes.profilePath : AppRoutes.loginPath,
        "routeName": isLoggedIn ? AppRoutes.profileRouteName : AppRoutes.loginRouteName,
      },
    ];

    final String currentLocation =  GoRouterState.of(context).uri.toString();

    return Container(
      height: 80,
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        border: Border(top: BorderSide(color: Color(0xFF2A2A2A), width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: navItems.map((item) {
          final String? itemPath = item['path'];
          final String? itemRouteName = item['routeName'];

          bool isSelected = false;
          if (itemPath != null) {
            if (itemPath == AppRoutes.homePath) {
              isSelected = (currentLocation == AppRoutes.homePath);
            } else if (itemPath == AppRoutes.cartPath) {
              isSelected = (currentLocation == AppRoutes.cartPath);
            } else if (itemPath == AppRoutes.loginPath) {
              isSelected = (currentLocation == AppRoutes.loginPath);
            }
            else if (itemPath == AppRoutes.profilePath) {
              isSelected = currentLocation.startsWith(AppRoutes.profilePath);
            }
          }

          return GestureDetector(
            onTap: () {
              if (itemRouteName != null) {
                context.goNamed(itemRouteName);
              } else if (item['label'] == 'WISHLIST') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Wishlist functionality coming soon!')), 
                );
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item['icon'],
                  color: isSelected ? const Color(0xFF00C896) : Colors.white54,
                  size: 24,
                ),
                const SizedBox(height: 4),
                Text(
                  item['label'],
                  style: TextStyle(
                    fontSize: 12,
                    color: isSelected ? const Color(0xFF00C896) : Colors.white54,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}