import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'review.dart';
import 'routes.dart';

class DetailsPage extends StatefulWidget {
  final Map<String, dynamic> product;

  const DetailsPage({super.key, required this.product});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  bool isFavorite = false;
  bool isAddedToCart = false;

  // Reviews list with initial 3 reviews
  List<Map<String, dynamic>> reviews = [
    {
      'text': 'Excellent joystick company! Their products are durable, responsive, and enhance gaming experience remarkably. Highly recommend!',
      'reviewer': 'Emon Hasan',
      'rating': 5,
      'timestamp': DateTime.now().subtract(const Duration(days: 5)),
    },
    {
      'text': 'Excellent joystick company! Their products are durable, responsive, and enhance gaming experience remarkably. Highly recommend!',
      'reviewer': 'Sarah Johnson',
      'rating': 4,
      'timestamp': DateTime.now().subtract(const Duration(days: 3)),
    },
    {
      'text': 'Excellent joystick company! Their products are durable, responsive, and enhance gaming experience remarkably. Highly recommend!',
      'reviewer': 'Mike Chen',
      'rating': 5,
      'timestamp': DateTime.now().subtract(const Duration(days: 1)),
    },
  ];

  // Function to add new review
  void addReview(Map<String, dynamic> newReview) {
    setState(() {
      reviews.insert(0, newReview); // Add new review at the beginning
    });
  }

  @override
  Widget build(BuildContext context) {
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
          onPressed: () => NavigationHelper.goBack(context), // Updated to use GoRouter
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
              widget.product['name'] ?? 'Nintendo Pro',
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
                      'Icons/controller.svg',
                      width: 200,
                      height: 150,
                      color: Colors.grey[600],
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
                          widget.product['name'] ?? 'Nintendo Pro',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${widget.product['sales'] ?? '1200'} Sales • ${widget.product['rating'] ?? '4.5'} Ratings',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '\$${widget.product['price'] ?? '310'}',
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

            // Product Images Row
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
                      'Icons/controller.svg',
                      width: 40,
                      height: 30,
                      color: Colors.grey[600],
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
                  'A sleek black joystick with neon accents and a comfortable grip for precise gaming control...',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),

            // Rating, Sales, Stock Row
            Row(
              children: [
                _buildInfoChip('${widget.product['rating'] ?? '4.5'} Rating'),
                const SizedBox(width: 12),
                _buildInfoChip('${widget.product['sales'] ?? '1200'} Sales'),
                const SizedBox(width: 12),
                _buildInfoChip('${widget.product['stock'] ?? '48'} Stock'),
              ],
            ),
            const SizedBox(height: 32),

            // Review Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Review',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Show review popup
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

            // Reviews List (Horizontal Scroll)
            SizedBox(
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
                          review['text'],
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
                                  color: Colors.grey[400],
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                review['reviewer'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            // Star rating display
                            Row(
                              children: List.generate(5, (starIndex) {
                                return Icon(
                                  Icons.star,
                                  size: 12,
                                  color: starIndex < review['rating']
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

            // Add to Cart Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    isAddedToCart = !isAddedToCart;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isAddedToCart ? Colors.grey[700] : Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  isAddedToCart ? 'Added to cart' : 'Add to cart',
                  style: const TextStyle(
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