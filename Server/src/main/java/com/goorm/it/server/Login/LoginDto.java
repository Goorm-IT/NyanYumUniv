package com.goorm.it.server.Login;

public class LoginDto {
    private String uid;
    private String nickName;
    private String userLevel;

    public String getUid(){
        return uid;
    }
    public String getNickName(){
        return nickName;
    }
    public String getUserLevel(){
        return userLevel;
    }
    public void setUid(String uid){
        this.uid = uid;
    }

    public void setNickName(String nickName){
        this.nickName = nickName;
    }
    public void setUserLevel(String userLevel){
        this.userLevel = userLevel;
    }
}
