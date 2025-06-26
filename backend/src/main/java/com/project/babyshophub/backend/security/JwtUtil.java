package com.project.babyshophub.backend.security;

import io.jsonwebtoken.*;
import io.jsonwebtoken.security.Keys;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;

import java.util.Base64;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.function.Function;
import javax.crypto.SecretKey;

@Component
public class JwtUtil {

    private static final Logger logger = LoggerFactory.getLogger(JwtUtil.class);

    @Value("${jwt.secret}")
    private String secret;

    @Value("${jwt.expirationMs}")
    private int jwtExpirationMs;

    private SecretKey signingKey;

    private SecretKey getSigningKey() {
        if (this.signingKey == null) {
            byte[] keyBytes;
            try {
                keyBytes = Base64.getDecoder().decode(secret);
                if (keyBytes.length < 64) {
                    logger.error("JWT secret key is too short for HS512. Expected at least 64 bytes, but got {} bytes. Please generate a stronger key.", keyBytes.length);
                    this.signingKey = Keys.secretKeyFor(SignatureAlgorithm.HS512);
                    logger.warn("Generated a new secure HS512 key programmatically. Please update application.properties with a strong Base64-encoded key.");
                } else {
                    this.signingKey = Keys.hmacShaKeyFor(keyBytes);
                }
            } catch (IllegalArgumentException e) {
                logger.error("JWT secret is not a valid Base64 string. Generating a new secure HS512 key programmatically.", e);
                this.signingKey = Keys.secretKeyFor(SignatureAlgorithm.HS512);
            }
        }
        return this.signingKey;
    }


    public String extractUsername(String token) {
        return extractClaim(token, Claims::getSubject);
    }

    public Date extractExpiration(String token) {
        return extractClaim(token, Claims::getExpiration);
    }

    public <T> T extractClaim(String token, Function<Claims, T> claimsResolver) {
        final Claims claims = extractAllClaims(token);
        return claimsResolver.apply(claims);
    }

    private Claims extractAllClaims(String token) {
        return Jwts.parserBuilder().setSigningKey(getSigningKey()).build().parseClaimsJws(token).getBody();
    }

    private Boolean isTokenExpired(String token) {
        return extractExpiration(token).before(new Date());
    }

    public String generateToken(UserDetails userDetails) {
        Map<String, Object> claims = new HashMap<>();
        return createToken(claims, userDetails.getUsername());
    }

    private String createToken(Map<String, Object> claims, String subject) {
        return Jwts.builder()
                .setClaims(claims)
                .setSubject(subject)
                .setIssuedAt(new Date(System.currentTimeMillis()))
                .setExpiration(new Date(System.currentTimeMillis() + jwtExpirationMs))
                .signWith(getSigningKey(), SignatureAlgorithm.HS512)
                .compact();
    }

    public Boolean validateToken(String token, UserDetails userDetails) {
        try {
            final String username = extractUsername(token);
            return (username.equals(userDetails.getUsername()) && !isTokenExpired(token));
        } catch (MalformedJwtException e) {
            logger.error("Invalid JWT token: {}", e.getMessage());
        } catch (ExpiredJwtException e) {
            logger.error("JWT token is expired: {}", e.getMessage());
        } catch (UnsupportedJwtException e) {
            logger.error("JWT token is unsupported: {}", e.getMessage());
        } catch (IllegalArgumentException e) {
            logger.error("JWT claims string is empty: {}", e.getMessage());
        } catch (io.jsonwebtoken.security.SignatureException e) {
            logger.error("Invalid JWT signature: {}", e.getMessage());
        }
        return false;
    }
}