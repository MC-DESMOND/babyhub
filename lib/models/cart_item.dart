class CartItem {
  final int? id;
  final int productId;
  final String productName;
  final String productImage;
  final int quantity;
  final int pricePerItem;
  final double subtotal;

  CartItem({
    this.id,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.quantity,
    required this.pricePerItem,
    required this.subtotal,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    final productJson = json['product'] as Map<String, dynamic>;
    return CartItem(
      id: json['id'],
      productId: productJson['id'],
      productName: productJson['name'],
      productImage: productJson['image'] ?? 'Icons/placeholder.svg',
      quantity: json['quantity'],
      pricePerItem: productJson['price'],
      subtotal: (productJson['price'] * json['quantity']).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'productName': productName,
      'productImage': productImage,
      'quantity': quantity,
      'pricePerItem': pricePerItem,
      'subtotal': subtotal,
    };
  }
}
