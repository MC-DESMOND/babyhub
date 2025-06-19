import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:babyhub/core/providers/product_provider.dart';
import 'package:babyhub/features/products/product_card.dart';

class ProductHistoryScreen extends ConsumerWidget {
  const ProductHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(productListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Purchase History"),
        backgroundColor: Colors.amber,
      ),
      body: productAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (products) {
          final historyProducts = products
              .where((p) =>
                  p.categoryKey == 'completed' || p.categoryKey == 'cancelled')
              .toList();

          if (historyProducts.isEmpty) {
            return const Center(child: Text("No purchase history yet."));
          }

          final isWide = MediaQuery.of(context).size.width > 600;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: isWide
                ? GridView.builder(
                    itemCount: historyProducts.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3.2,
                    ),
                    itemBuilder: (_, i) =>
                        ProductCard(product: historyProducts[i]),
                  )
                : ListView.builder(
                    itemCount: historyProducts.length,
                    itemBuilder: (_, i) =>
                        ProductCard(product: historyProducts[i]),
                  ),
          );
        },
      ),
    );
  }
}
