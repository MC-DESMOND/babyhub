package com.project.babyshophub.backend.payload.response;

public class JwtResponse {
    private String token;
    private String type = "Bearer";
    private int id;
    private String email;
    private String name;

    public JwtResponse(String accessToken, int id, String email, String name) {
        this.token = accessToken;
        this.id = id;
        this.email = email;
        this.name = name;
    }

    public String getAccessToken() {
        return token;
    }

    public void setAccessToken(String accessToken) {
        this.token = accessToken;
    }

    public String getTokenType() {
        return type;
    }

    public void setTokenType(String tokenType) {
        this.type = tokenType;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}