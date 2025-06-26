package com.project.babyshophub.backend.dto;

import java.util.List;

public class CategoryDto {
    private int id;
    private String name;
    private List<Integer> productsIdList;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public List<Integer> getProductsIdList() {
        return productsIdList;
    }

    public void setProductsIdList(List<Integer> productsIdList) {
        this.productsIdList = productsIdList;
    }
}