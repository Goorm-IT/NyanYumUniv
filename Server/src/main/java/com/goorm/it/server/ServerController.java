package com.goorm.it.server;



import java.util.List;
import java.util.Map;

import com.goorm.it.server.RegisterUser.RegisterUserDao;
import com.goorm.it.server.RegisterUser.RegisterUserDto;
import com.goorm.it.server.UserInfo.UserInfoDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import com.goorm.it.server.UserInfo.UserInfoDao;


//TODO: Main Controller, DAO, DTO(=VO) 공부하기

@RestController
@SpringBootApplication
public class ServerController {

    public static void main(String[] args) {
        SpringApplication.run(ServerController.class, args);
    }

    @Autowired UserInfoDao UIFD;

    @RequestMapping("/select")
    public List<Map<String, ?>> getMessage(){
        return UIFD.selectAll();
    }
    @PostMapping("/selectUid")
    public List<Map<String, Object>> checkUser(@RequestBody UserInfoDto userInfoDto){
        return UIFD.checkUser(userInfoDto.getUid());
    }

    @PostMapping("/register")
    public List<Map<String,?>> registerUser(@RequestBody RegisterUserDto registerUserDto){
        return RegisterUserDao.add(registerUserDto.getUid(),registerUserDto.getNickName());
    }



}