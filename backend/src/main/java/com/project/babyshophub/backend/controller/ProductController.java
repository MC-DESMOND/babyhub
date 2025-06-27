package com.project.babyshophub.backend.controller;

import java.io.IOException;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.project.babyshophub.backend.dto.ProductDto;
import com.project.babyshophub.backend.entity.Product;
import com.project.babyshophub.backend.service.ProductService;



@RestController
public class ProductController {

    @Autowired
    private ProductService productService;

    @RequestMapping(value = "product/info", method = RequestMethod.GET)
    public String info() {
        return "Product application is up...";
    }

    @PostMapping(value = "product/create", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<String> createProduct(
            @RequestPart("product") Product product,
            @RequestPart(value = "image", required = false) MultipartFile imageFile) {
        try {
            String message = productService.createProduct(product, imageFile);
            return ResponseEntity.ok(message);
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Failed to upload image: " + e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(e.getMessage());
        }
    }

    @RequestMapping(value = "product/readall", method = RequestMethod.GET)
    public List<ProductDto> readProducts() {
        return productService.readProductDtos();
    }

    @RequestMapping(value = "product/read/{id}", method = RequestMethod.GET)
    public ResponseEntity<ProductDto> readProductById(@PathVariable int id) {
        Optional<ProductDto> productDto = productService.readProductDtoById(id);
        return productDto.map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PutMapping(value = "product/update", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<String> updateProduct(
            @RequestPart("product") Product product,
            @RequestPart(value = "image", required = false) MultipartFile imageFile) {
        try {
            String message = productService.updateProduct(product, imageFile);
            if (message.contains("not found") || message.contains("does not exist")) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(message);
            }
            return ResponseEntity.ok(message);
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Failed to update image: " + e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(e.getMessage());
        }
    }

    @RequestMapping(value = "product/delete/{id}", method = RequestMethod.DELETE)
    public String deleteProduct(@PathVariable int id) {
        return productService.deleteProduct(id);
    }
}