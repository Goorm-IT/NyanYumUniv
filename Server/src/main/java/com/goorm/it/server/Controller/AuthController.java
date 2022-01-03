//package com.goorm.it.server.Controller;
//
//
//import com.goorm.it.server.Login.LoginDto;
//import com.goorm.it.server.RegisterUser.RegisterUserDto;
//import org.springframework.http.MediaType;
//import org.springframework.stereotype.Controller;
//import org.springframework.web.bind.annotation.*;
//
//import java.awt.*;
//
//@RestController
//@RequestMapping("/auth")
//public class AuthController {
//
//    @PostMapping(value = "login", produces = MediaType.APPLICATION_JSON_VALUE)
//    public String login(@RequestBody LoginDto loginDto){
//        return "login";
//    }
//
//    @PostMapping(value = "signup", produces = MediaType.APPLICATION_JSON_VALUE)
//    public String signup(@RequestBody RegisterUserDto registerUserDto){
//        return "signup";
//    }
//}
