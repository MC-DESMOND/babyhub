import 'package:babyhub/core/models/product.dart';

class DummyService {
  Future<List<Product>> fetchProducts() async {
    await Future.delayed(const Duration(seconds: 1)); // simulate network delay

    return [
      Product(
        productId: '1',
        name: 'Galaxy S24',
        description: 'Latest Samsung flagship phone',
        price: 999.99,
        stockQuantity: 20,
        categoryKey: 'completed',
        imageUrl: 'https://via.placeholder.com/150',
        createdAt: DateTime.now(),
        reviews: [],
      ),
      Product(
        productId: '2',
        name: 'Nike Air Max',
        description: 'Comfortable running shoes',
        price: 199.99,
        stockQuantity: 50,
        categoryKey: 'cancelled',
        imageUrl: 'https://via.placeholder.com/150',
        createdAt: DateTime.now().subtract(Duration(days: 2)),
        reviews: [],
      ),
      Product(
        productId: '3',
        name: 'MacBook Pro 16"',
        description: 'Powerful laptop for developers and creatives',
        price: 2499.00,
        stockQuantity: 8,
        categoryKey: 'favorites',
        imageUrl: 'https://via.placeholder.com/150',
        createdAt: DateTime.now().subtract(Duration(days: 10)),
        reviews: [],
      ),
      Product(
        productId: '4',
        name: 'Baby Diapers',
        description: 'Pack of 50 ultra-absorbent diapers',
        price: 25.00,
        stockQuantity: 100,
        categoryKey: 'completed',
        imageUrl: 'https://via.placeholder.com/150',
        createdAt: DateTime.now().subtract(Duration(days: 1)),
        reviews: [],
      ),
    ];
  }
}
