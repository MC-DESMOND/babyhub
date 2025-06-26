package com.project.babyshophub.backend.repository;

import com.project.babyshophub.backend.entity.CartItem;
import com.project.babyshophub.backend.entity.Cart;
import com.project.babyshophub.backend.entity.Product;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface CartItemRepository extends JpaRepository<CartItem, Integer> {
    Optional<CartItem> findByCartAndProduct(Cart cart, Product product);

    @Query("select max(ci.id) from CartItem ci")
    public Integer findMaxId();
}