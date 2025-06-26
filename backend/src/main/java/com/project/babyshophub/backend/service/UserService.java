package com.project.babyshophub.backend.service;

import com.project.babyshophub.backend.entity.User;
import com.project.babyshophub.backend.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder; // Added
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.util.List;
import java.util.Optional; // Added

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder encoder; // Injected PasswordEncoder

    @Transactional
    public String createUser(User user){
        try {
            if (!userRepository.existsByEmail(user.getEmail())){
                user.setId(null == userRepository.findMaxId()? 1 : userRepository.findMaxId() + 1);
                user.setPassword(encoder.encode(user.getPassword())); // Encode password
                userRepository.save(user);
                return "User record created successfully.";
            }else {
                return "User with this email already exists in the database.";
            }
        }catch (Exception e){
            throw e;
        }
    }

    public List<User> readUsers(){
        return userRepository.findAll();
    }

    @Transactional
    public String updateUser(User user){
        // For update, we might not always update password.
        // If password is provided, encode it. Otherwise, keep existing.
        if (userRepository.existsByEmail(user.getEmail())){
            try {
                Optional<User> existingUserOptional = userRepository.findByEmail(user.getEmail());
                if(existingUserOptional.isPresent()){
                    User userToBeUpdate = existingUserOptional.get();
                    userToBeUpdate.setName(user.getName());
                    // Only update email if it's different and not already taken by another user
                    if (!userToBeUpdate.getEmail().equals(user.getEmail()) && userRepository.existsByEmail(user.getEmail())) {
                        return "New email is already in use by another user.";
                    }
                    userToBeUpdate.setEmail(user.getEmail());

                    // If a new password is provided, encode and set it
                    if (user.getPassword() != null && !user.getPassword().isEmpty()) {
                        userToBeUpdate.setPassword(encoder.encode(user.getPassword()));
                    }                   userRepository.save(userToBeUpdate);
                    return "User record updated.";
                } else {
                    return "User not found for update.";
                }
            }catch (Exception e){
                throw e;
            }
        }else {
            return "User does not exists in the database.";
        }
    }

    @Transactional
    public String deleteUser(User user){
        if (userRepository.existsByEmail(user.getEmail())){
            try {
                Optional<User> userOptional = userRepository.findByEmail(user.getEmail()); // Use Optional
                userOptional.ifPresent(u -> {
                    userRepository.delete(u);
                });
                return "User record deleted successfully.";
            }catch (Exception e){
                throw e;
            }
        }else {
            return "User does not exist";
        }
    }
}