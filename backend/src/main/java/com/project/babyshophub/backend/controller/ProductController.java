package com.project.babyshophub.backend.controller;

import com.project.babyshophub.backend.entity.Product;
import com.project.babyshophub.backend.service.ProductService;
import com.project.babyshophub.backend.dto.ProductDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.PathVariable;

import java.util.List;
import java.util.Optional;

@RestController
public class ProductController {

    @Autowired
    private ProductService productService;

    @RequestMapping(value = "product/info", method = RequestMethod.GET)
    public String info(){
        return "Product application is up...";
    }

    @RequestMapping(value = "product/create", method = RequestMethod.POST)
    public String createProduct(@RequestBody Product product){
        return productService.createProduct(product);
    }

    @RequestMapping(value = "product/readall", method = RequestMethod.GET)
    public List<ProductDto> readProducts(){
        return productService.readProductDtos();
    }

    @RequestMapping(value = "product/read/{id}", method = RequestMethod.GET)
    public ResponseEntity<ProductDto> readProductById(@PathVariable int id) {
        Optional<ProductDto> productDto = productService.readProductDtoById(id);
        return productDto.map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @RequestMapping(value = "product/update", method = RequestMethod.PUT)
    public String updateProduct(@RequestBody Product product){
        return productService.updateProduct(product);
    }

    @RequestMapping(value = "product/delete/{id}", method = RequestMethod.DELETE)
    public String deleteProduct(@PathVariable int id){
        return productService.deleteProduct(id);
    }
}