// lib/controllers/orders_controller.dart
import 'package:get/get.dart';
import '../models/review.dart';
import '../models/rating_data.dart';

class OrdersController extends GetxController {
  // Observable variables
  var currentUser = 'Guy Hawkins'.obs;
  var totalReviews = 52.obs;
  var averageRating = 4.0.obs;
  var reviews = <Review>[].obs;
  var ratingDistribution = <RatingData>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  void loadData() {
    // Load mock reviews data
    reviews.value = [
      Review(
        id: '1',
        userName: 'Courtney Henry',
        userImage: 'https://images.unsplash.com/photo-1494790108755-2616b612b000?w=100&h=100&fit=crop&crop=face',
        rating: 5,
        comment: 'Consequat velit qui adipisicing sunt do rependerit ad laborum tempor ullamco exercitation. Ullamco tempor adipisicing et voluptate duis sit esse aliqua',
        timestamp: DateTime.now().subtract(Duration(minutes: 2)),
      ),
      Review(
        id: '2',
        userName: 'Cameron Williamson',
        userImage: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop&crop=face',
        rating: 4,
        comment: 'Consequat velit qui adipisicing sunt do rependerit ad laborum tempor ullamco.',
        timestamp: DateTime.now().subtract(Duration(minutes: 2)),
      ),
      Review(
        id: '3',
        userName: 'Jane Cooper',
        userImage: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100&h=100&fit=crop&crop=face',
        rating: 3,
        comment: 'Ullamco tempor adipisicing et voluptate duis sit esse aliqua esse ex.',
        timestamp: DateTime.now().subtract(Duration(minutes: 2)),
      ),
    ];

    // Load rating distribution data
    ratingDistribution.value = [
      RatingData(stars: 5, count: 32, percentage: 0.8),
      RatingData(stars: 4, count: 12, percentage: 0.6),
      RatingData(stars: 3, count: 6, percentage: 0.3),
      RatingData(stars: 2, count: 2, percentage: 0.1),
      RatingData(stars: 1, count: 0, percentage: 0.0),
    ];
  }

  // Method to refresh data
  void refreshData() {
    loadData();
  }
}