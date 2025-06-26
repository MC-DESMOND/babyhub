package com.project.babyshophub.backend.service;

import com.project.babyshophub.backend.entity.Cart;
import com.project.babyshophub.backend.entity.CartItem;
import com.project.babyshophub.backend.entity.Product;
import com.project.babyshophub.backend.entity.User;
import com.project.babyshophub.backend.repository.CartItemRepository;
import com.project.babyshophub.backend.repository.CartRepository;
import com.project.babyshophub.backend.repository.ProductRepository;
import com.project.babyshophub.backend.repository.UserRepository;
import com.project.babyshophub.backend.dto.CartDto;
import com.project.babyshophub.backend.dto.CartItemDto;
import com.project.babyshophub.backend.dto.ProductDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class CartService {

    @Autowired
    private CartRepository cartRepository;

    @Autowired
    private CartItemRepository cartItemRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private ProductService productService;

    @Transactional
    public Cart getOrCreateCartForUser(int userId) {
        Optional<User> userOptional = userRepository.findById(userId);
        if (userOptional.isEmpty()) {
            throw new RuntimeException("User not found with ID: " + userId);
        }
        User user = userOptional.get();

        Optional<Cart> existingCart = cartRepository.findByUser(user);
        if (existingCart.isPresent()) {
            return existingCart.get();
        } else {
            Cart newCart = new Cart();
            Integer maxId = cartRepository.findMaxId();
            newCart.setId(maxId == null ? 1 : maxId + 1);
            newCart.setUser(user);
            return cartRepository.save(newCart);
        }
    }

    @Transactional
    public String addProductToCart(int userId, int productId, int quantity) {
        if (quantity <= 0) {
            return "Quantity must be greater than zero.";
        }

        Cart cart = getOrCreateCartForUser(userId);

        Optional<Product> productOptional = productRepository.findById(productId);
        if (productOptional.isEmpty()) {
            return "Product not found with ID: " + productId;
        }
        Product product = productOptional.get();

        Optional<CartItem> existingCartItem = cartItemRepository.findByCartAndProduct(cart, product);

        if (existingCartItem.isPresent()) {
            CartItem cartItem = existingCartItem.get();
            cartItem.setQuantity(cartItem.getQuantity() + quantity);
            // No need to explicitly save cartItem here, as it's already a managed entity
            // and its state change will be flushed at the end of the transaction.
            return "Product quantity updated in cart.";
        } else {
            CartItem newCartItem = new CartItem();
            Integer maxId = cartItemRepository.findMaxId();
            newCartItem.setId(maxId == null ? 1 : maxId + 1);
            newCartItem.setCart(cart);
            newCartItem.setProduct(product);
            newCartItem.setQuantity(quantity);
            cart.addCartItem(newCartItem);
            // No need to explicitly save newCartItem here if Cart has cascade=ALL on cartItems.
            // The newCartItem will be persisted when the parent Cart is flushed.
            return "Product added to cart.";
        }
    }

    @Transactional
    public String updateProductQuantityInCart(int userId, int productId, int newQuantity) {
        Cart cart = getOrCreateCartForUser(userId);

        Optional<Product> productOptional = productRepository.findById(productId);
        if (productOptional.isEmpty()) {
            return "Product not found with ID: " + productId;
        }
        Product product = productOptional.get();

        Optional<CartItem> existingCartItem = cartItemRepository.findByCartAndProduct(cart, product);

        if (existingCartItem.isPresent()) {
            CartItem cartItem = existingCartItem.get();
            if (newQuantity <= 0) {
                cartItemRepository.delete(cartItem);
                cart.removeCartItem(cartItem);
                return "Product removed from cart as quantity is zero or less.";
            } else {
                cartItem.setQuantity(newQuantity);
                // No need to explicitly save cartItem here, as it's already a managed entity
                // and its state change will be flushed at the end of the transaction.
                return "Product quantity updated in cart.";
            }
        } else {
            return "Product not found in cart.";
        }
    }

    @Transactional
    public String removeProductFromCart(int userId, int productId) {
        Cart cart = getOrCreateCartForUser(userId);

        Optional<Product> productOptional = productRepository.findById(productId);
        if (productOptional.isEmpty()) {
            return "Product not found with ID: " + productId;
        }
        Product product = productOptional.get();

        Optional<CartItem> existingCartItem = cartItemRepository.findByCartAndProduct(cart, product);

        if (existingCartItem.isPresent()) {
            CartItem cartItem = existingCartItem.get();
            cartItemRepository.delete(cartItem);
            cart.removeCartItem(cartItem);
            return "Product removed from cart.";
        } else {
            return "Product not found in cart.";
        }
    }

    @Transactional
    public String clearCart(int userId) {
        Optional<User> userOptional = userRepository.findById(userId);
        if (userOptional.isEmpty()) {
            return "User not found with ID: " + userId;
        }
        User user = userOptional.get();
        Optional<Cart> cartOptional = cartRepository.findByUser(user);

        if (cartOptional.isPresent()) {
            Cart cart = cartOptional.get();
            cartItemRepository.deleteAll(cart.getCartItems());
            cart.getCartItems().clear();
            return "Cart cleared successfully.";
        } else {
            return "Cart not found for user.";
        }
    }

    public Optional<CartDto> getCartDtoForUser(int userId) {
        Optional<User> userOptional = userRepository.findById(userId);
        if (userOptional.isEmpty()) {
            return Optional.empty();
        }
        User user = userOptional.get();
        Optional<Cart> cartOptional = cartRepository.findByUser(user);

        return cartOptional.map(this::convertToCartDto);
    }

    private CartDto convertToCartDto(Cart cart) {
        CartDto cartDto = new CartDto();
        cartDto.setId(cart.getId());
        cartDto.setUserId(cart.getUser().getId());

        List<CartItemDto> itemDtos = cart.getCartItems().stream()
                .map(this::convertToCartItemDto)
                .collect(Collectors.toList());
        cartDto.setCartItems(itemDtos);

        double totalCost = itemDtos.stream()
                .mapToDouble(item -> item.getProduct().getPrice() * item.getQuantity())
                .sum();
        cartDto.setTotalCost(totalCost);

        return cartDto;
    }

    private CartItemDto convertToCartItemDto(CartItem cartItem) {
        CartItemDto cartItemDto = new CartItemDto();
        cartItemDto.setId(cartItem.getId());
        cartItemDto.setQuantity(cartItem.getQuantity());
        cartItemDto.setCartId(cartItem.getCart().getId());

        if (cartItem.getProduct() != null) {
            Optional<ProductDto> productDtoOptional = productService.readProductDtoById(cartItem.getProduct().getId());
            productDtoOptional.ifPresent(cartItemDto::setProduct);
        }
        return cartItemDto;
    }
}