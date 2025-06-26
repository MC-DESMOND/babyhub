package com.project.babyshophub.backend.service;

import com.project.babyshophub.backend.entity.Product;
import com.project.babyshophub.backend.entity.Review;
import com.project.babyshophub.backend.entity.User;
import com.project.babyshophub.backend.repository.ProductRepository;
import com.project.babyshophub.backend.repository.ReviewRepository;
import com.project.babyshophub.backend.repository.UserRepository;
import com.project.babyshophub.backend.dto.ReviewDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class ReviewService {

    @Autowired
    private ReviewRepository reviewRepository;

    @Autowired
    public ProductRepository productRepository;

    @Autowired
    private UserRepository userRepository;

    @Transactional
    public String createReview(ReviewDto reviewDto) {
        Optional<Product> productOptional = productRepository.findById(reviewDto.getProductId());
        Optional<User> userOptional = userRepository.findById(reviewDto.getUserId());

        if (productOptional.isEmpty()) {
            return "Product not found with ID: " + reviewDto.getProductId();
        }
        if (userOptional.isEmpty()) {
            return "User not found with ID: " + reviewDto.getUserId();
        }

        Review review = new Review();
        Integer maxId = reviewRepository.findMaxId();
        review.setId(maxId == null ? 1 : maxId + 1);
        review.setText(reviewDto.getText());
        review.setRating(reviewDto.getRating());
        review.setProduct(productOptional.get());
        review.setUser(userOptional.get());
        // reviewDate is set automatically by constructor

        reviewRepository.save(review);
        return "Review added successfully.";
    }

    public List<ReviewDto> getReviewsByProductId(int productId) {
        List<Review> reviews = reviewRepository.findByProductId(productId);
        return reviews.stream().map(this::convertToDto).collect(Collectors.toList());
    }

    private ReviewDto convertToDto(Review review) {
        ReviewDto dto = new ReviewDto();
        dto.setId(review.getId());
        dto.setProductId(review.getProduct().getId());
        dto.setUserId(review.getUser().getId());
        dto.setReviewerName(review.getUser().getName()); // Get reviewer name from User entity
        dto.setText(review.getText());
        dto.setRating(review.getRating());
        dto.setReviewDate(review.getReviewDate());
        return dto;
    }
}
