package com.project.babyshophub.backend.controller;
import com.project.babyshophub.backend.entity.User;
import com.project.babyshophub.backend.payload.request.LoginRequest;
import com.project.babyshophub.backend.payload.response.JwtResponse;
import com.project.babyshophub.backend.repository.UserRepository;
import com.project.babyshophub.backend.security.JwtUtil;
import com.project.babyshophub.backend.service.UserDetailsServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@RestController
@RequestMapping("/auth")
public class AuthController {

    @Autowired
    AuthenticationManager authenticationManager;

    @Autowired
    UserRepository userRepository;

    @Autowired
    JwtUtil jwtUtil;

    @PostMapping("/signin")
    public ResponseEntity<?> authenticateUser(@RequestBody LoginRequest loginRequest) {

        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(loginRequest.getEmail(), loginRequest.getPassword()));
        System.out.println(authentication.isAuthenticated());
        SecurityContextHolder.getContext().setAuthentication(authentication);
        String jwt = jwtUtil.generateToken((UserDetails) authentication.getPrincipal());

        Optional<User> userOptional = userRepository.findByEmail(loginRequest.getEmail());
        if (userOptional.isPresent()) {
            User user = userOptional.get();
            System.out.println(user.getEmail());
            return ResponseEntity.ok(new JwtResponse(jwt,
                    user.getId(),
                    user.getEmail(),
                    user.getName()));
        } else {
            return ResponseEntity.status(404).body("User not found after authentication.");
        }
    }
}