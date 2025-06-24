import 'category.dart';

class Product {
  final int id;
  final String name;
  final String image;
  final String? description;
  final int price;
  final Category category;
  final double? averageRating;
  final int sales; // New field for sales
  final int stock; // New field for stock

  Product({
    required this.id,
    required this.name,
    required this.image,
    this.description,
    required this.price,
    required this.category,
    this.averageRating,
    required this.sales, // Make sales required
    required this.stock, // Make stock required
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      image: json['image'] ?? 'Icons/placeholder.svg',
      description: json['description'],
      price: (json['price'] as int?) ?? 0,
      category: Category.fromJson(json['category']),
      averageRating: (json['averageRating'] as num?)?.toDouble(),
      sales: (json['sales'] as int?) ?? 0, // Parse sales
      stock: (json['stock'] as int?) ?? 0, // Parse stock
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'description': description,
      'price': price,
      'category': category.toJson(),
      'averageRating': averageRating,
      'sales': sales,
      'stock': stock,
    };
  }
}
