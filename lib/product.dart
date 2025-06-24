import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'routes.dart';

class ProductPage extends StatefulWidget {
  final List<Map<String, dynamic>> products;
  final String? searchQuery;

  const ProductPage({
    super.key,
    required this.products,
    this.searchQuery,
  });

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  void navigateToDetails(Map<String, dynamic> product) {
    NavigationHelper.goToDetails(
      context,
      product: {
        'id': product['id'], // Ensure product ID is passed
        'name': product['name'],
        'price': product['price'], // Pass price as is (should be int)
        'rating': product['rating'], // Pass rating as is from map
        'sales': product['sales'], // Pass sales as is from map
        'stock': '48', // Default stock value, not from backend yet
        'description': product['description'] ?? 'A sleek black joystick with neon accents and a comfortable grip for precise gaming control.', // Use description from product map
        'image': product['image'], // Pass image from product map
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _buildProductsGrid(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => NavigationHelper.goBack(context),
            child: Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(22.5),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white70,
                size: 18,
              ),
            ),
          ),
          const Expanded(
            child: Center(
              child: Text(
                "Products",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 45),
        ],
      ),
    );
  }

  Widget _buildProductsGrid() {
    if (widget.products.isEmpty) {
      return const Center(
        child: Text(
          "No products available in this category.",
          style: TextStyle(color: Colors.white54, fontSize: 16),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 15,
          mainAxisSpacing: 20,
        ),
        itemCount: widget.products.length,
        itemBuilder: (context, index) {
          final product = widget.products[index];
          return _buildProductCard(product);
        },
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return GestureDetector(
      onTap: () => navigateToDetails(product),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3A3A3A),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        product['image'],
                        width: 80,
                        height: 80,
                        fit: BoxFit.contain,
                        placeholderBuilder: (context) => Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.grey[600],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            product['name'].contains('Nintendo')
                                ? Icons.gamepad
                                : Icons.headphones,
                            color: Colors.white54,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 20,
                    right: 20,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          product['isFavorite'] = !product['isFavorite'];
                        });
                      },
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(17.5),
                        ),
                        child: Icon(
                          product['isFavorite']
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: product['isFavorite']
                              ? Colors.red
                              : Colors.white70,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(15, 0, 15, 15),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${product['sales']} • ${product['rating']}",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Spacer(),
                      Text(
                        '\$${product['price']}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}