// lib/widgets/review_card.dart
import 'package:flutter/material.dart';
import '../models/review.dart';

class ReviewCard extends StatelessWidget {
  final Review review;

  const ReviewCard({Key? key, required this.review}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User avatar
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(review.userImage),
              ),
              SizedBox(width: 12),
              
              // Review content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User name and menu button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          review.userName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            // Handle menu action
                          },
                          icon: Icon(
                            Icons.more_vert,
                            color: Colors.grey[400],
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    
                    // Rating stars and timestamp
                    Row(
                      children: [
                        // Star rating
                        Row(
                          children: List.generate(5, (index) =>
                            Icon(
                              Icons.star,
                              color: index < review.rating 
                                  ? Colors.amber 
                                  : Colors.grey[600],
                              size: 16,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        
                        // Timestamp
                        Text(
                          '2 mins ago',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    
                    // Review comment
                    Text(
                      review.comment,
                      style: TextStyle(
                        color: Colors.grey[300],
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          
          // Divider
          Divider(
            color: Colors.grey[800],
            height: 1,
          ),
        ],
      ),
    );
  }
}