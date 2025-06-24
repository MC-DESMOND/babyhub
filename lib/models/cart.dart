import 'cart_item.dart';

class Cart {
  final int? id;
  final int userId;
  final List<CartItem> cartItems;
  final double totalCost;

  Cart({
    this.id,
    required this.userId,
    required this.cartItems,
    required this.totalCost,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'],
      userId: json['userId'],
      cartItems: (json['cartItems'] as List<dynamic>)
          .map((e) => CartItem.fromJson(e))
          .toList(),
      totalCost: (json['totalCost'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'cartItems': cartItems.map((e) => e.toJson()).toList(),
      'totalCost': totalCost,
    };
  }
}
