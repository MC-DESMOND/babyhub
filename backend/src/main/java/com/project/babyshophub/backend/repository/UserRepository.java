package com.project.babyshophub.backend.repository;

import com.project.babyshophub.backend.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.Optional; // Changed List to Optional for findByEmail

@Repository
public interface UserRepository extends JpaRepository<User, Integer> {
    public boolean existsByEmail(String email);
    public Optional<User> findByEmail(String email); // Changed return type to Optional<User>
    @Query("select max(u.id) from User u")
    public Integer findMaxId();
}