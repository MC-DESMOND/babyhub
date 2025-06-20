import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:babyhub/core/providers/product_provider.dart';
import 'package:babyhub/features/products/product_card.dart';

class ProductHistoryScreen extends ConsumerStatefulWidget {
  const ProductHistoryScreen({super.key});

  @override
  ConsumerState<ProductHistoryScreen> createState() => _ProductHistoryScreenState();
}

class _ProductHistoryScreenState extends ConsumerState<ProductHistoryScreen> {
  String selectedFilter = 'Favorite'; // Default filter

  @override
  Widget build(BuildContext context) {
    final productAsync = ref.watch(productListProvider);

    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            "Wishlist",
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            // Page Title
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Product History",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            
            // Filter Pills
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  _buildFilterPill("Favorite", true),
                  const SizedBox(width: 12),
                  _buildFilterPill("Completed", false),
                  const SizedBox(width: 12),
                  _buildFilterPill("Cancelled", false),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Product List
            Expanded(
              child: productAsync.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(color: Colors.green),
                ),
                error: (e, _) => Center(
                  child: Text(
                    'Error: $e',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                data: (products) {
                  final filteredProducts = _getFilteredProducts(products);

                  if (filteredProducts.isEmpty) {
                    return const Center(
                      child: Text(
                        "No products found.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      return ProductCard(
                        product: filteredProducts[index],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
        
        // Bottom Navigation
        bottomNavigationBar: _buildBottomNavigation(),
      ),
    );
  }

  Widget _buildFilterPill(String label, bool isActive) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? Colors.green : Colors.grey[800],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  List<Product> _getFilteredProducts(List<Product> products) {
    switch (selectedFilter) {
      case 'Completed':
        return products.where((p) => p.categoryKey == 'completed').toList();
      case 'Cancelled':
        return products.where((p) => p.categoryKey == 'cancelled').toList();
      default:
        return products.where((p) => p.categoryKey == 'favorite').toList();
    }
  }

  Widget _buildBottomNavigation() {
    return Container(
      height: 80,
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, "HOME", false),
          _buildNavItem(Icons.favorite_border, "WISHLIST", true),
          _buildNavItem(Icons.shopping_bag_outlined, "CART", false),
          _buildNavItem(Icons.person_outline, "LOGIN", false),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: isActive ? Colors.green : Colors.grey,
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.green : Colors.grey,
            fontSize: 12,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}