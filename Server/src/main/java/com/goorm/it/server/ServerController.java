package com.goorm.it.server;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.RestController;
import com.goorm.it.server.UserInfo.UserInfoDao;
import com.goorm.it.server.RegisterUser.RegisterUserDao;


//TODO: Main Controller, DAO, DTO(=VO) 공부하기, Session 유지 추가

@RestController
@SpringBootApplication
public class ServerController {

    public static void main(String[] args) {
        SpringApplication.run(ServerController.class, args);
    }

    @Autowired UserInfoDao infoDao;

    @RequestMapping("/select")
    public List<Map<String, ?>> getMessage(){
        return infoDao.selectAll();
    }

    @RequestMapping("/register")
    public List<Map<String, ?>> getRegister(){
        return RegisterUserDao.add();
    }


}