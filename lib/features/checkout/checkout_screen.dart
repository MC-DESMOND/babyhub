import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:babyhub/core/providers/cart_provider.dart';
import 'package:intl/intl.dart';

class CheckoutScreen extends ConsumerWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);
    final formatter = NumberFormat.currency(symbol: '₦');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Colors.amber,
      ),
      body: cartItems.isEmpty
          ? const Center(child: Text('Your cart is empty.'))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      itemCount: cartItems.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (_, i) {
                        final item = cartItems[i];
                        return ListTile(
                          title: Text(item.product.name),
                          subtitle: Text('Qty: ${item.quantity}'),
                          trailing: Text(formatter.format(item.product.price * item.quantity)),
                        );
                      },
                    ),
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        formatter.format(cartNotifier.totalPrice),
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Simulate order completion
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Order placed successfully!')),
                      );
                      ref.read(cartProvider.notifier).clearCart();
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.check),
                    label: const Text('Place Order'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                  ),
                ],
              ),
            ),
    );
  }
}
