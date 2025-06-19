import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:babyhub/core/providers/cart_provider.dart';
import 'package:intl/intl.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);
    final formatter = NumberFormat.currency(symbol: '₦');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        backgroundColor: Colors.amber,
      ),
      body: cartItems.isEmpty
          ? const Center(child: Text('Your cart is empty.'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (_, i) {
                      final item = cartItems[i];
                      return ListTile(
                        leading: Image.network(item.product.imageUrl ?? ''),
                        title: Text(item.product.name),
                        subtitle: Text('Qty: ${item.quantity}'),
                        trailing: Text(
                          formatter.format(item.product.price * item.quantity),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      );
                    },
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
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
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/checkout');
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                  child: const Text('Proceed to Checkout'),
                ),
                const SizedBox(height: 16),
              ],
            ),
    );
  }
}
