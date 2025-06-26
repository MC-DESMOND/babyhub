package com.project.babyshophub.backend.controller;

import com.project.babyshophub.backend.dto.ReviewDto;
import com.project.babyshophub.backend.service.ReviewService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/reviews")
public class ReviewController {

    @Autowired
    private ReviewService reviewService;

    @PostMapping("/create")
//    @PreAuthorize("hasAnyAuthority('USER', 'ADMIN')") // Example: only logged-in users can create reviews
    public ResponseEntity<String> createReview(@RequestBody ReviewDto reviewDto) {
        String message = reviewService.createReview(reviewDto);
        if (message.contains("not found")) {
            return ResponseEntity.badRequest().body(message);
        }
        return ResponseEntity.ok(message);
    }

    @GetMapping("/product/{productId}")
    public ResponseEntity<List<ReviewDto>> getReviewsByProductId(@PathVariable int productId) {
        List<ReviewDto> reviews = reviewService.getReviewsByProductId(productId);
        if (reviews.isEmpty() && !reviewService.productRepository.existsById(productId)) {
            // If no reviews and product itself doesn't exist, return 404
            return ResponseEntity.notFound().build();
        } else if (reviews.isEmpty()) {
            // If product exists but no reviews, return 200 with empty list
            return ResponseEntity.ok(reviews);
        }
        return ResponseEntity.ok(reviews);
    }
}
