package com.goorm.it.server;

import java.util.List;
import java.util.Map;


import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;


//TODO: Main Controller, DAO, DTO(=VO) 공부하기

@EnableAsync
@SpringBootApplication
public class ServerController {

    public static void main(String[] args) {
        SpringApplication.run(ServerController.class, args);
    }


}