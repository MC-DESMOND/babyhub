import 'package:freezed_annotation/freezed_annotation.dart';
import 'product.dart';

part 'cart_item.freezed.dart';
part 'cart_item.g.dart';

@freezed
class CartItem with _$CartItem {
  const factory CartItem({
    required Product product,

    @Default(1) int quantity,
  }) = _CartItem;

  factory CartItem.fromJson(Map<String, dynamic> json) => 
      _$CartItemFromJson(json);
}

extension CartItemExtension on CartItem {
  double get totalPrice => product.price * quantity;

  CartItem updateQuantity(int newQuantity) {
    assert(newQuantity > 0, 'Quantity must be positive');
    return copyWith(quantity: newQuantity);
  }

  CartItem incrementQuantity() => copyWith(quantity: quantity + 1);

  CartItem decrementQuantity() => 
      copyWith(quantity: quantity > 1 ? quantity - 1 : 1);
}