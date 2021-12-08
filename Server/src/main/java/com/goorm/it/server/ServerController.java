package com.goorm.it.server;



import java.util.List;
import java.util.Map;

import com.goorm.it.server.UserInfo.UserInfoDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.RestController;
import com.goorm.it.server.UserInfo.UserInfoDao;


//TODO: Main Controller, DAO, DTO(=VO) 공부하기

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
    @PostMapping("/selectUid")
    public List<Map<String, Object>> selectUid(@RequestBody UserInfoDto userInfoDto){
        return infoDao.selectUid(userInfoDto.getUid());
    }


}