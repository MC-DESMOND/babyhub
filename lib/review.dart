import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ReviewPopup extends StatefulWidget {
  final Function(Map<String, dynamic>) onReviewSubmitted;

  const ReviewPopup({super.key, required this.onReviewSubmitted});

  @override
  State<ReviewPopup> createState() => _ReviewPopupState();
}

class _ReviewPopupState extends State<ReviewPopup> {
  int selectedStars = 3; // Default to 3 stars as shown in image
  final TextEditingController reviewController = TextEditingController();

  @override
  void dispose() {
    reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.8,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 50,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // Title
                      const Text(
                        'WRITE YOUR REVIEW',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Star Rating
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedStars = index + 1;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              child: Icon(
                                Icons.star,
                                size: 40,
                                color: index < selectedStars
                                    ? const Color(0xFFFFD700) // Gold color
                                    : Colors.white.withOpacity(0.3),
                              ),
                            ),
                          );
                        }),
                      ),

                      const SizedBox(height: 32),

                      // Review Text Field
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextField(
                            controller: reviewController,
                            maxLines: null,
                            expands: true,
                            textAlignVertical: TextAlignVertical.top,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                            decoration: const InputDecoration(
                              hintText: 'Write your review',
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Post Review Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            if (reviewController.text.trim().isNotEmpty) {
                              // Create review data
                              Map<String, dynamic> newReview = {
                                'text': reviewController.text.trim(),
                                'rating': selectedStars,
                                'reviewer': 'You', // Default reviewer name
                                'timestamp': DateTime.now(),
                              };

                              // Call the callback function
                              widget.onReviewSubmitted(newReview);

                              // Close the popup using GoRouter
                              context.pop();
                            } else {
                              // Show error if review is empty
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please write a review before submitting'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00C853),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'POST REVIEW',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Function to show the review popup
void showReviewPopup(BuildContext context, Function(Map<String, dynamic>) onReviewSubmitted) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => ReviewPopup(onReviewSubmitted: onReviewSubmitted),
  );
}