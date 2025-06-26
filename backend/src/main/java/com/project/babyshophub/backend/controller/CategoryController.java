package com.project.babyshophub.backend.controller;

import com.project.babyshophub.backend.entity.Category;
import com.project.babyshophub.backend.service.CategoryService;
import com.project.babyshophub.backend.dto.CategoryDto;
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
public class CategoryController {

    @Autowired
    private CategoryService categoryService;

    @RequestMapping(value = "category/info", method = RequestMethod.GET)
    public String info(){
        return "Category application is up...";
    }

    @RequestMapping(value = "category/create", method = RequestMethod.POST)
    public String createCategory(@RequestBody Category category){
        return categoryService.createCategory(category);
    }

    @RequestMapping(value = "category/readall", method = RequestMethod.GET)
    public List<CategoryDto> readCategories(){
        return categoryService.readCategoryDtos();
    }

    @RequestMapping(value = "category/read/{id}", method = RequestMethod.GET)
    public ResponseEntity<CategoryDto> readCategoryById(@PathVariable int id) {
        Optional<CategoryDto> categoryDto = categoryService.readCategoryDtoById(id);
        return categoryDto.map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @RequestMapping(value = "category/update", method = RequestMethod.PUT)
    public String updateCategory(@RequestBody Category category){
        return categoryService.updateCategory(category);
    }

    @RequestMapping(value = "category/delete/{id}", method = RequestMethod.DELETE)
    public String deleteCategory(@PathVariable int id){
        return categoryService.deleteCategory(id);
    }
}