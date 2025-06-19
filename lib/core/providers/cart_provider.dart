import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void addToCart(Product product) {
    final index = state.indexWhere((item) => item.product.productId == product.productId);
    if (index >= 0) {
      final updatedItem = state[index].copyWith(quantity: state[index].quantity + 1);
      state = [...state]..[index] = updatedItem;
    } else {
      state = [...state, CartItem(product: product, quantity: 1)];
    }
  }

  void removeFromCart(String productId) {
    state = state.where((item) => item.product.productId != productId).toList();
  }

  void clearCart() {
    state = [];
  }

  double get totalPrice {
    return state.fold(0, (sum, item) => sum + (item.product.price * item.quantity));
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});
