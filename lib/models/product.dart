import 'category.dart';

class Product {
  final int id;
  final String name;
  final String image; // Assuming this will be a URL or identifier
  final Category category; // This links to the Category entity

  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      image: json['image'] ?? 'Icons/placeholder.svg', // Default if image is null
      category: Category.fromJson(json['category']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'category': category.toJson(),
    };
  }
}