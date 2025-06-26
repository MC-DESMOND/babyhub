package com.project.babyshophub.backend.controller;

import com.project.babyshophub.backend.entity.User;
import com.project.babyshophub.backend.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
public class UserController {

    @Autowired
    private UserService userService;

    @RequestMapping(value = "user/info", method = RequestMethod.GET)
    public String info(){
        return "User application is up...";
    }

    @RequestMapping(value = "user/create", method = RequestMethod.POST)
    public String createUser(@RequestBody User user){
        return userService.createUser(user);
    }

    @RequestMapping(value = "user/readall", method = RequestMethod.GET)
    public List<User> readUsers(){
        return userService.readUsers();
    }

    @RequestMapping(value = "user/update", method = RequestMethod.PUT)
    public String updateUser(@RequestBody User user){
        return userService.updateUser(user);
    }

    @RequestMapping(value = "user/delete", method = RequestMethod.DELETE)
    public String deleteUser(@RequestBody User user){
        return userService.deleteUser(user);
    }
}