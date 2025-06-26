package com.project.babyshophub.backend.service;

import com.project.babyshophub.backend.entity.Product;
import com.project.babyshophub.backend.entity.Review;
import com.project.babyshophub.backend.repository.ProductRepository;
import com.project.babyshophub.backend.repository.ReviewRepository;
import com.project.babyshophub.backend.dto.ProductDto;
import com.project.babyshophub.backend.dto.CategoryDto;
import com.project.babyshophub.backend.dto.ReviewDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class ProductService {

    @Autowired
    private ProductRepository productRepository;

    @Autowired 
    private CategoryService categoryService;

    @Autowired
    private ReviewService reviewService; // Inject ReviewService

    @Transactional
    public String createProduct(Product product){
        try {
            if (!productRepository.existsById(product.getId())){
                product.setId(null == productRepository.findMaxId()? 1 : productRepository.findMaxId() + 1);
                productRepository.save(product);
                return "Product record created successfully.";
            }else {
                return "Product with this ID already exists in the database.";
            }
        }catch (Exception e){
            throw e;
        }
    }

    public List<Product> readProducts(){
        return productRepository.findAll();
    }

    public List<ProductDto> readProductDtos() {
        List<Product> products = productRepository.findAll();
        return products.stream().map(this::convertToProductDto).collect(Collectors.toList());
    }

    public Optional<ProductDto> readProductDtoById(int id) {
        return productRepository.findById(id)
                .map(this::convertToProductDto);
    }

    private ProductDto convertToProductDto(Product product) {
        ProductDto productDto = new ProductDto();
        productDto.setId(product.getId());
        productDto.setName(product.getName());
        productDto.setDescription(product.getDescription());
        productDto.setImage(product.getImage());
        productDto.setPrice(product.getPrice());
        productDto.setSales(product.getSales()); // Set sales
        productDto.setStock(product.getStock()); // Set stock

        if (product.getCategory() != null) {
            Optional<CategoryDto> categoryDtoOptional = categoryService.readCategoryDtoById(product.getCategory().getId());
            categoryDtoOptional.ifPresent(productDto::setCategory);
        }

        // Convert and set reviews
        List<ReviewDto> reviewDtos = reviewService.getReviewsByProductId(product.getId());
        productDto.setReviews(reviewDtos);

        // Calculate and set average rating
        if (reviewDtos != null && !reviewDtos.isEmpty()) {
            double averageRating = reviewDtos.stream()
                    .mapToInt(ReviewDto::getRating)
                    .average()
                    .orElse(0.0);
            productDto.setAverageRating(Math.round(averageRating * 10.0) / 10.0); // Round to one decimal place
        } else {
            productDto.setAverageRating(0.0);
        }

        return productDto;
    }

    @Transactional
    public String updateProduct(Product product){
        if (productRepository.existsById(product.getId())){
            try {
                Optional<Product> existingProductOptional = productRepository.findById(product.getId());
                if(existingProductOptional.isPresent()){
                    Product productToBeUpdated = existingProductOptional.get();
                    productToBeUpdated.setName(product.getName());
                    productToBeUpdated.setDescription(product.getDescription());
                    productToBeUpdated.setImage(product.getImage());
                    productToBeUpdated.setPrice(product.getPrice());
                    productToBeUpdated.setCategory(product.getCategory());
                    productToBeUpdated.setSales(product.getSales()); // Update sales
                    productToBeUpdated.setStock(product.getStock()); // Update stock
                    productRepository.save(productToBeUpdated);
                    return "Product record updated.";
                } else {
                    return "Product not found for update.";
                }
            }catch (Exception e){
                throw e;
            }
        }else {
            return "Product does not exist in the database.";
        }
    }

    @Transactional
    public String deleteProduct(int id){
        if (productRepository.existsById(id)){
            try {
                productRepository.deleteById(id);
                return "Product record deleted successfully.";
            }catch (Exception e){
                throw e;
            }
        }else {
            return "Product does not exist";
        }
    }
}
