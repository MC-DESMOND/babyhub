import 'category.dart';

class Product {
  final int id;
  final String name;
  final String image;
  final String? description;
  final int price; // Changed to int for price
  final Category category;

  Product({
    required this.id,
    required this.name,
    required this.image,
    this.description,
    required this.price,
    required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      image: json['image'] ?? 'Icons/placeholder.svg',
      description: json['description'],
      price: (json['price'] as int?) ?? 0, // Safely parse price to int
      category: Category.fromJson(json['category']),
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
    };
  }
}
