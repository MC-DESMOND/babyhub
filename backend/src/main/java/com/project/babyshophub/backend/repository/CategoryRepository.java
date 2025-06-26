package com.project.babyshophub.backend.repository;

import com.project.babyshophub.backend.entity.Category;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

@Repository
public interface CategoryRepository extends JpaRepository<Category,Integer> {
    @Query("select max(c.id) from Category c")
    public Integer findMaxId();
}