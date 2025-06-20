import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../providers/delivery_provider.dart';
import '../providers/payment_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white70),
          onPressed: () => context.canPop() ? context.pop() : null,
        ),
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Profile',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 28,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer3<UserProvider, DeliveryProvider, PaymentProvider>(
              builder: (context, userProvider, deliveryProvider, paymentProvider, child) {
                if (userProvider.isLoading || deliveryProvider.isLoading || paymentProvider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                }

                return ListView(
                  padding: const EdgeInsets.all(20.0),
                  children: [
                    _buildMenuItem(
                      title: 'Personal Information',
                      subtitle: 'Edit your account information',
                      trailing: userProvider.user.name,
                      onTap: () => context.pushNamed('personal-information'),
                    ),
                    _buildMenuItem(
                      title: 'Update Your Password',
                      subtitle: 'Set a new account password',
                      onTap: () => context.pushNamed('update-password'),
                    ),
                    _buildMenuItem(
                      title: 'Delivery Information',
                      subtitle: 'Manage your delivery addresses',
                      trailing: '${deliveryProvider.addresses.length} addresses',
                      onTap: () => context.pushNamed('delivery-information'),
                    ),
                    _buildMenuItem(
                      title: 'Payment Methods',
                      subtitle: 'Manage your payment methods',
                      trailing: '${paymentProvider.paymentMethods.length} methods',
                      onTap: () => context.pushNamed('payment-methods'),
                    ),
                  ],
                );
              },
            ),
          ),
          _buildBottomNavigation(),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required String title,
    required String subtitle,
    String? trailing,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 1.0),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 19,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 1.0),
              child: Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.white60,
                  fontSize: 16,
                ),
              ),
            ),
            if (trailing != null)
              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Text(
                  trailing,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.white60,
          size: 16,
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        border: Border(
          top: BorderSide(color: Colors.white12, width: 0.5),
        ),
      ),
      child: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(Icons.home_outlined, 'HOME', false, () {}),
              _buildNavItem(Icons.favorite_border, 'WISHLIST', false, () {}),
              _buildNavItem(Icons.shopping_cart_outlined, 'CART', false, () {}),
              _buildNavItem(Icons.person_outline, 'LOGIN', true, () {}),
            ],
          );
        },
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.white : Colors.white60,
            size: 25,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white60,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
