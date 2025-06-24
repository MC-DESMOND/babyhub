import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../providers/user_provider.dart';
import '../providers/delivery_provider.dart';
import '../providers/payment_provider.dart';
import '../widgets/app_bottom_navigation_bar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get controller instances
    final UserProvider userProvider = Get.find<UserProvider>();
    final DeliveryProvider deliveryProvider = Get.find<DeliveryProvider>();
    final PaymentProvider paymentProvider = Get.find<PaymentProvider>();

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
            child: Obx(() { // Use Obx to react to isLoading from multiple providers
              if (userProvider.isLoading ||
                  deliveryProvider.isLoading ||
                  paymentProvider.isLoading) {
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
                    trailing: userProvider.user.name, // Reacts to userProvider changes
                    onTap: () => context.pushNamed('personal-information'),
                  ),
                  _buildMenuItem(
                    title: 'Update Your Password',
                    subtitle: 'Set a new account password',
                    onTap: () => context.pushNamed('update-password'),
                  ),
                  Obx(() => _buildMenuItem(
                        title: 'Delivery Information',
                        subtitle: 'Manage your delivery addresses',
                        trailing: '${deliveryProvider.addresses.length} addresses', // Reacts to deliveryProvider changes
                        onTap: () => context.pushNamed('delivery-information'),
                      )),
                  Obx(() => _buildMenuItem(
                        title: 'Payment Methods',
                        subtitle: 'Manage your payment methods',
                        trailing: '${paymentProvider.paymentMethods.length} methods', // Reacts to paymentProvider changes
                        onTap: () => context.pushNamed('payment-methods'),
                      )),
                ],
              );
            }),
          ),
          // No need for Obx here as isLoggedIn is managed by HomePage for now
          AppBottomNavigationBar(isLoggedIn: userProvider.user.id != 0), 
        ],
      ),
    );
  }
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