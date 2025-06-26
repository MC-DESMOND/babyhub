package com.project.babyshophub.backend.service;

import com.project.babyshophub.backend.entity.Category;
import com.project.babyshophub.backend.repository.CategoryRepository;
import com.project.babyshophub.backend.dto.CategoryDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class CategoryService {

    @Autowired
    private CategoryRepository categoryRepository;

    @Transactional
    public String createCategory(Category category){
        try {
            if (!categoryRepository.existsById(category.getId())){
                category.setId(null == categoryRepository.findMaxId()? 1 : categoryRepository.findMaxId() + 1);
                categoryRepository.save(category);
                return "Category record created successfully.";
            }else {
                return "Category with this ID already exists in the database.";
            }
        }catch (Exception e){
            throw e;
        }
    }

    public List<Category> readCategories(){
        return categoryRepository.findAll();
    }

    public List<CategoryDto> readCategoryDtos() {
        List<Category> categories = categoryRepository.findAll();
        return categories.stream().map(this::convertToCategoryDto).collect(Collectors.toList());
    }

    public Optional<CategoryDto> readCategoryDtoById(int id) {
        return categoryRepository.findById(id)
                .map(this::convertToCategoryDto);
    }

    private CategoryDto convertToCategoryDto(Category category) {
        CategoryDto categoryDto = new CategoryDto();
        categoryDto.setId(category.getId());
        categoryDto.setName(category.getName());
        if (category.getProductList() != null) {
            categoryDto.setProductsIdList(category.getProductList().stream()
                                            .map(product -> product.getId())
                                            .collect(Collectors.toList()));
        }
        return categoryDto;
    }

    @Transactional
    public String updateCategory(Category category){
        if (categoryRepository.existsById(category.getId())){
            try {
                Optional<Category> existingCategoryOptional = categoryRepository.findById(category.getId());
                if(existingCategoryOptional.isPresent()){
                    Category categoryToBeUpdated = existingCategoryOptional.get();
                    categoryToBeUpdated.setName(category.getName());
                    categoryToBeUpdated.setDescription(category.getDescription());
                    categoryRepository.save(categoryToBeUpdated);
                    return "Category record updated.";
                } else {
                    return "Category not found for update.";
                }
            }catch (Exception e){
                throw e;
            }
        }
else {
            return "Category does not exist in the database.";
        }
    }

    @Transactional
    public String deleteCategory(int id){
        if (categoryRepository.existsById(id)){
            try {
                categoryRepository.deleteById(id);
                return "Category record deleted successfully.";
            }catch (Exception e){
                throw e;
            }
        }
else {
            return "Category does not exist.";
        }
    }
}