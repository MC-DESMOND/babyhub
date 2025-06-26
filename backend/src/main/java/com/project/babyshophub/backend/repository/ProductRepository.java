package com.project.babyshophub.backend.repository;

import com.project.babyshophub.backend.entity.Product;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

@Repository
public interface ProductRepository extends JpaRepository<Product,Integer> {
    @Query("select max(p.id) from Product p")
    public Integer findMaxId();
}