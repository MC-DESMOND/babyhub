import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../routes.dart';
import '../services/cart_service.dart';
import '../services/auth_service.dart';
import '../models/cart.dart';
import '../models/cart_item.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartService _cartService = CartService();
  final AuthService _authService = AuthService();
  Cart? _cart;
  bool _isLoading = true;
  String _errorMessage = '';
  int? _currentUserId;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final currentUser = await _authService.getCurrentUser();
      if (currentUser == null) {
        setState(() {
          _errorMessage = 'User not logged in. Please log in to view your cart.';
          _isLoading = false;
        });
        NavigationHelper.goToLogin(context); // Redirect to login
        return;
      }
      _currentUserId = currentUser.id;
      final fetchedCart = await _cartService.getCartByUserId(_currentUserId!);
      setState(() {
        _cart = fetchedCart;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load cart: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _updateItemQuantity(int productId, int newQuantity) async {
    if (_currentUserId == null) return;
    setState(() {
      _isLoading = true;
    });
    final response = await _cartService.updateCartItemQuantity(_currentUserId!, productId, newQuantity);
    if (response != null && !response.contains('Failed')) {
      _showSnackBar('Cart updated successfully!', isError: false);
      await _loadCart(); // Reload cart after update
    } else {
      _showSnackBar(response ?? 'Failed to update cart.', isError: true);
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _removeItem(int productId) async {
    if (_currentUserId == null) return;
    setState(() {
      _isLoading = true;
    });
    final response = await _cartService.removeItemFromCart(_currentUserId!, productId);
    if (response != null && !response.contains('Failed')) {
      _showSnackBar('Item removed successfully!', isError: false);
      await _loadCart(); // Reload cart after removal
    } else {
      _showSnackBar(response ?? 'Failed to remove item.', isError: true);
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _clearCart() async {
    if (_currentUserId == null) return;
    setState(() {
      _isLoading = true;
    });
    final response = await _cartService.clearCart(_currentUserId!);
    if (response != null && !response.contains('Failed')) {
      _showSnackBar('Cart cleared successfully!', isError: false);
      await _loadCart(); // Reload cart after clearing
    } else {
      _showSnackBar(response ?? 'Failed to clear cart.', isError: true);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => NavigationHelper.goBack(context),
        ),
        title: const Text('Your Cart', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          if (_cart != null && _cart!.cartItems.isNotEmpty && !_isLoading)
            TextButton(
              onPressed: _clearCart,
              child: const Text(
                'Clear Cart',
                style: TextStyle(color: Colors.redAccent, fontSize: 16),
              ),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF00C896)))
          : _errorMessage.isNotEmpty
              ? Center(
                  child: Text(
                    _errorMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                )
              : (_cart == null || _cart!.cartItems.isEmpty)
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'Icons/empty_cart.svg', // Assuming you have an empty cart SVG
                            width: 150,
                            height: 150,
                            colorFilter: const ColorFilter.mode(Colors.white38, BlendMode.srcIn),
                            placeholderBuilder: (context) => const Icon(
                              Icons.shopping_cart_outlined,
                              color: Colors.white38,
                              size: 150,
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Your cart is empty!',
                            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Add some products to your cart to see them here.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white54, fontSize: 16),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () {
                              NavigationHelper.goHome(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00C896),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                            ),
                            child: const Text('Start Shopping', style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _cart!.cartItems.length,
                            itemBuilder: (context, index) {
                              final item = _cart!.cartItems[index];
                              return _buildCartItemCard(item);
                            },
                          ),
                        ),
                        _buildCheckoutSummary(),
                      ],
                    ),
    );
  }

  Widget _buildCartItemCard(CartItem item) {
    return Card(
      color: const Color(0xFF2A2A2A),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[700],
                borderRadius: BorderRadius.circular(10),
              ),
              child: SvgPicture.asset(
                item.productImage,
                width: 50,
                height: 50,
                fit: BoxFit.contain,
                colorFilter: const ColorFilter.mode(Colors.white54, BlendMode.srcIn),
                placeholderBuilder: (context) => const Icon(
                  Icons.image,
                  color: Colors.white54,
                  size: 40,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${item.pricePerItem.toStringAsFixed(2)} per item',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF00C896),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, color: Colors.white),
                              onPressed: () => _updateItemQuantity(item.productId, item.quantity - 1),
                              constraints: const BoxConstraints(),
                              padding: EdgeInsets.zero,
                            ),
                            Text(
                              '${item.quantity}',
                              style: const TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, color: Colors.white),
                              onPressed: () => _updateItemQuantity(item.productId, item.quantity + 1),
                              constraints: const BoxConstraints(),
                              padding: EdgeInsets.zero,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        '\$${item.subtotal.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: () => _removeItem(item.productId),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckoutSummary() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: const BoxDecoration(
        color: Color(0xFF2A2A2A),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total:',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '\$${_cart?.totalCost.toStringAsFixed(2) ?? '0.00'}',
                style: const TextStyle(
                  color: Color(0xFF00C896),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                // Implement checkout logic here
                _showSnackBar('Checkout functionality not yet implemented!', isError: false);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00C896),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              child: const Text(
                'PROCEED TO CHECKOUT',
                style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
