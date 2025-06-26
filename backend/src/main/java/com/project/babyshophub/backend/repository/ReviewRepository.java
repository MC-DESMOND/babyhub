package com.project.babyshophub.backend.repository;

import com.project.babyshophub.backend.entity.Review;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ReviewRepository extends JpaRepository<Review, Integer> {
    List<Review> findByProductId(int productId);

    @Query("select max(r.id) from Review r")
    public Integer findMaxId();
}
