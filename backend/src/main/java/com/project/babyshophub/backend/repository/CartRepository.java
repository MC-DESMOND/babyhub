package com.project.babyshophub.backend.repository;

import com.project.babyshophub.backend.entity.Cart;
import com.project.babyshophub.backend.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface CartRepository extends JpaRepository<Cart, Integer> {
    Optional<Cart> findByUser(User user);

    @Query("select max(c.id) from Cart c")
    public Integer findMaxId();
}