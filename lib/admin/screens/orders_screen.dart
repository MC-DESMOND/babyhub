// lib/screens/orders_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../controllers/orders_controllers.dart';
import '../widgets/rating_bar.dart';
import '../widgets/review_card.dart';

class OrdersScreen extends StatelessWidget {
  final OrdersController controller = Get.put(OrdersController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          _buildHeader(context),
          _buildReviewsList(),
        ],
      ),
    );
  }

  // Custom App Bar
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      leading: Padding(
        padding: EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundImage: NetworkImage(
            'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&h=100&fit=crop&crop=face'
          ),
          child: Align(
            alignment: Alignment.bottomRight,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 2),
              ),
            ),
          ),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() => Text(
            controller.currentUser.value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          )),
          Text(
            'Admin',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[400],
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.search, color: Colors.white),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.menu, color: Colors.white),
        ),
      ],
    );
  }

  // Header Section
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBreadcrumb(context),
          SizedBox(height: 24),
          _buildTitle(),
          SizedBox(height: 24),
          _buildRatingOverview(),
        ],
      ),
    );
  }

  // Breadcrumb Navigation
  Widget _buildBreadcrumb(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => context.go('/dashboard'),
          child: Text(
            'Dashboard',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
            ),
          ),
        ),
        Icon(Icons.chevron_right, color: Colors.grey[400], size: 16),
        SizedBox(width: 4),
        Text(
          'Reports/Feedback',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  // Page Title
  Widget _buildTitle() {
    return Text(
      'Orders',
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  // Rating Overview Section
  Widget _buildRatingOverview() {
    return Row(
      children: [
        // Rating Distribution Bars
        Expanded(
          flex: 2,
          child: Column(
            children: [
              Obx(() => Column(
                children: controller.ratingDistribution.map((rating) =>
                  RatingBar(rating: rating)
                ).toList(),
              )),
            ],
          ),
        ),
        SizedBox(width: 40),
        
        // Average Rating Display
        Expanded(
          child: Column(
            children: [
              Obx(() => Text(
                controller.averageRating.value.toString(),
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) =>
                  Icon(
                    Icons.star,
                    color: index < 4 ? Colors.amber : Colors.grey[600],
                    size: 20,
                  ),
                ),
              ),
              SizedBox(height: 8),
              Obx(() => Text(
                '${controller.totalReviews.value} Reviews',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14,
                ),
              )),
            ],
          ),
        ),
      ],
    );
  }

  // Reviews List
  Widget _buildReviewsList() {
    return Expanded(
      child: Obx(() => ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 20),
        itemCount: controller.reviews.length,
        itemBuilder: (context, index) {
          final review = controller.reviews[index];
          return ReviewCard(review: review);
        },
      )),
    );
  }
}