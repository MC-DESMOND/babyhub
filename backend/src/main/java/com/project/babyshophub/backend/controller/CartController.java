package com.project.babyshophub.backend.controller;

import com.project.babyshophub.backend.service.CartService;
import com.project.babyshophub.backend.dto.CartDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@RestController
@RequestMapping("/cart")
public class CartController {

    @Autowired
    private CartService cartService;

    @GetMapping("/{userId}")
    @PreAuthorize("#userId == authentication.principal.id")
    public ResponseEntity<CartDto> getCart(@PathVariable int userId) {
        Optional<CartDto> cartDto = cartService.getCartDtoForUser(userId);
        return cartDto.map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping("/add/{userId}/{productId}/{quantity}")
    @PreAuthorize("#userId == authentication.principal.id")
    public ResponseEntity<String> addProduct(@PathVariable int userId,
                                             @PathVariable int productId,
                                             @PathVariable int quantity) {
        String message = cartService.addProductToCart(userId, productId, quantity);
        if (message.contains("not found")) {
            return ResponseEntity.badRequest().body(message);
        }
        return ResponseEntity.ok(message);
    }

    @PutMapping("/update/{userId}/{productId}/{newQuantity}")
    @PreAuthorize("#userId == authentication.principal.id")
    public ResponseEntity<String> updateProductQuantity(@PathVariable int userId,
                                                        @PathVariable int productId,
                                                        @PathVariable int newQuantity) {
        String message = cartService.updateProductQuantityInCart(userId, productId, newQuantity);
        if (message.contains("not found")) {
            return ResponseEntity.badRequest().body(message);
        }
        return ResponseEntity.ok(message);
    }

    @DeleteMapping("/remove/{userId}/{productId}")
    @PreAuthorize("#userId == authentication.principal.id")
    public ResponseEntity<String> removeProduct(@PathVariable int userId,
                                                @PathVariable int productId) {
        String message = cartService.removeProductFromCart(userId, productId);
        if (message.contains("not found")) {
            return ResponseEntity.badRequest().body(message);
        }
        return ResponseEntity.ok(message);
    }

    @DeleteMapping("/clear/{userId}")
    @PreAuthorize("#userId == authentication.principal.id")
    public ResponseEntity<String> clearUserCart(@PathVariable int userId) {
        String message = cartService.clearCart(userId);
        if (message.contains("not found")) {
            return ResponseEntity.badRequest().body(message);
        }
        return ResponseEntity.ok(message);
    }
}