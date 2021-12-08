package com.goorm.it.server.RegisterUser;

public class RegisterUserDto {
    private String uid;
    private String nickName;


    public String getUid(){
        return uid;
    }

    public String getNickName(){
        return nickName;
    }

    public void setUid(String uid){
        this.uid = uid;
    }

    public void setNickName(String nickName){
        this.nickName = nickName;
    }
}
