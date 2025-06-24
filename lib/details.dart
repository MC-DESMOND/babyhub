import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'review.dart';
import 'routes.dart';
import 'services/cart_service.dart';
import 'services/auth_service.dart';
import 'services/review_service.dart'; // Import ReviewService
import 'models/review.dart'; // Import Review model

class DetailsPage extends StatefulWidget {
  final Map<String, dynamic> product;

  const DetailsPage({super.key, required this.product});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  bool isFavorite = false; // Local UI state
  final CartService _cartService = CartService();
  final AuthService _authService = AuthService();
  final ReviewService _reviewService = ReviewService(); // Instantiate ReviewService
  int? _currentUserId;

  List<Review> reviews = []; // Changed to dynamic list of Review objects
  bool _isLoadingReviews = true;
  String _reviewsErrorMessage = '';

  @override
  void initState() {
    super.initState();
    // Initialize isFavorite based on product data if available
    isFavorite = widget.product['isFavorite'] as bool? ?? false;
    _checkUserAndCartStatus();
    _loadReviews(); // Load reviews when the page initializes
  }

  Future<void> _checkUserAndCartStatus() async {
    final currentUser = await _authService.getCurrentUser();
    if (currentUser != null) {
      _currentUserId = currentUser.id;
    }
  }

  Future<void> _loadReviews() async {
    setState(() {
      _isLoadingReviews = true;
      _reviewsErrorMessage = '';
    });
    try {
      final fetchedReviews = await _reviewService.getReviewsForProduct(widget.product['id']);
      setState(() {
        reviews = fetchedReviews ?? []; // Use empty list if null
        _isLoadingReviews = false;
      });
    } catch (e) {
      setState(() {
        _reviewsErrorMessage = 'Failed to load reviews: $e';
        _isLoadingReviews = false;
      });
    }
  }

  // Function to add new review
  void addReview(Map<String, dynamic> newReviewData) async {
    if (_currentUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please log in to submit a review.'),
          backgroundColor: Colors.red,
        ),
      );
      NavigationHelper.goToLogin(context);
      return;
    }

    setState(() {
      _isLoadingReviews = true;
    });

    final response = await _reviewService.createReview(
      _currentUserId!,
      widget.product['id'],
      newReviewData['text'],
      newReviewData['rating'],
    );

    if (response != null && !response.contains('Failed')) {
      _showSnackBar('Review submitted successfully!', isError: false);
      await _loadReviews(); // Reload reviews after submitting
    } else {
      _showSnackBar(response ?? 'Failed to submit review.', isError: true);
    }
    setState(() {
      _isLoadingReviews = false;
    });
  }

  Future<void> _handleAddToCart() async {
    if (_currentUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please log in to add items to your cart.'),
          backgroundColor: Colors.red,
        ),
      );
      NavigationHelper.goToLogin(context);
      return;
    }

    final response = await _cartService.addItemToCart(
      _currentUserId!,
      widget.product['id'], // Assuming 'id' is passed in the product map
      1, // Add one quantity by default
    );

    if (response != null && !response.contains('Failed')) {
      _showSnackBar('Product added to cart successfully!', isError: false);
    } else {
      _showSnackBar(response ?? 'Failed to add product to cart.', isError: true);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  String _formatDate(DateTime date) {
    // Manual date formatting without intl package
    final List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    // Use product average rating if available, otherwise default
    final double averageRating = widget.product['averageRating'] is num
        ? (widget.product['averageRating'] as num).toDouble() : 0.0;
    final String formattedAverageRating = averageRating.toStringAsFixed(1);

    // Use actual sales and stock from product map
    final int sales = widget.product['sales'] as int? ?? 0;
    final int stock = widget.product['stock'] as int? ?? 0;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 18,
            ),
          ),
          onPressed: () => NavigationHelper.goBack(context),
        ),
        title: const Text(
          'Details',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Title
            Text(
              widget.product['name'] ?? 'Product Name',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            // Main Product Image Container
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(24),
              ),
              child: Stack(
                children: [
                  Center(
                    child: SvgPicture.asset(
                      widget.product['image'] ?? 'Icons/controller.svg', // Use product image
                      width: 200,
                      height: 150,
                      colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                      placeholderBuilder: (context) => const Icon(Icons.image, color: Colors.grey, size: 100),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isFavorite = !isFavorite;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Product Info Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.product['name'] ?? 'Product Name',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          // Display actual average rating from backend
                          '$formattedAverageRating Rating \u2022 $sales Sales',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '\$${(widget.product['price'] as int).toStringAsFixed(2)}', // Display actual price
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Product Images Row (still hardcoded SVG, as backend only has one image field)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(3, (index) {
                return Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'Icons/controller.svg', // Still hardcoded for additional images
                      width: 40,
                      height: 30,
                      colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 32),

            // Description Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Description',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  Icons.more_vert,
                  color: Colors.grey[400],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              widget.product['description'] ??
                  'A sleek black joystick with neon accents and a comfortable grip for precise gaming control. This is a placeholder description as it is not fetched from the backend product entity.', // Description is hardcoded
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),

            // Rating, Sales, Stock Row (now using backend average rating)
            Row(
              children: [
                _buildInfoChip('$formattedAverageRating Rating'), // Use formatted average rating
                const SizedBox(width: 12),
                _buildInfoChip('$sales Sales'), // Use actual sales
                const SizedBox(width: 12),
                _buildInfoChip('$stock Stock'), // Use actual stock
              ],
            ),
            const SizedBox(height: 32),

            // Review Section (now dynamic reviews)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Reviews',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showReviewPopup(context, addReview);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Give a Review',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            _isLoadingReviews
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF00C896)))
                : _reviewsErrorMessage.isNotEmpty
                    ? Center(
                        child: Text(
                          _reviewsErrorMessage,
                          style: const TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      )
                    : (reviews.isEmpty)
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 20.0),
                              child: Text(
                                'No reviews yet. Be the first to review!',
                                style: TextStyle(color: Colors.white54, fontSize: 16),
                              ),
                            ),
                          )
                        : SizedBox(
                            height: 120,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: reviews.length,
                              itemBuilder: (context, index) {
                                final review = reviews[index];
                                return Container(
                                  width: 280,
                                  margin: EdgeInsets.only(right: index < reviews.length - 1 ? 16 : 0),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[900],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        review.text,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          height: 1.4,
                                        ),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const Spacer(),
                                      Row(
                                        children: [
                                          Container(
                                            width: 32,
                                            height: 32,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[700],
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: SvgPicture.asset(
                                                'Icons/profile.svg',
                                                width: 20,
                                                height: 20,
                                                colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  review.reviewerName,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  _formatDate(review.reviewDate), // Formatted date
                                                  style: TextStyle(
                                                    color: Colors.grey[400],
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Star rating display
                                          Row(
                                            children: List.generate(5, (starIndex) {
                                              return Icon(
                                                Icons.star,
                                                size: 12,
                                                color: starIndex < review.rating
                                                    ? const Color(0xFFFFD700)
                                                    : Colors.grey[600],
                                              );
                                            }),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
            const SizedBox(height: 32),

            // Add to Cart Button (local state)
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _handleAddToCart, // Call the new handler
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00C896), // Always green for 'Add to cart'
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Add to cart',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.grey[300],
          fontSize: 12,
        ),
      ),
    );
  }
}
