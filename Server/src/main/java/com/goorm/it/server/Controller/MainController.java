package com.goorm.it.server.Controller;

import com.goorm.it.server.RegisterUser.RegisterUserDao;
import com.goorm.it.server.RegisterUser.RegisterUserDto;
import com.goorm.it.server.UserInfo.UserInfoDao;
import com.goorm.it.server.UserInfo.UserInfoDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.Map;

@RestController
public class MainController {
    @Autowired UserInfoDao UIFD;
    @Autowired RegisterUserDao RUD;

    @RequestMapping("/select")
    public List<Map<String, ?>> getMessage(){
            return UIFD.selectAll();
    }

    @PostMapping("/selectUid")
    public List<Map<String, Object>> checkUser(@RequestBody UserInfoDto userInfoDto){
            return UIFD.checkUser(userInfoDto.getUid());
    }

    @PostMapping("/register")
    public List<Map<String,?>> registerUser(@ModelAttribute RegisterUserDto registerUserDto){
            return RUD.add(registerUserDto.getUid(),registerUserDto.getNickName());
    }

}
