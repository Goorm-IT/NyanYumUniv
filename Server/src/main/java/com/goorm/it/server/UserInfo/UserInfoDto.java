package com.goorm.it.server.UserInfo;

public class UserInfoDto {
    private String id;
    private String nickName;
    private String userLevel;
    private int postId;

    public String getId(){
        return id;
    }
    public String getNickName(){
        return nickName;
    }
    public String getUserLevel(){
        return userLevel;
    }
    public int getPostId(){
        return postId;
    }

    public void setId(String id){
        this.id = id;
    }

    public void setNickName(String nickName) {
        this.nickName = nickName;
    }

    public void setUserLevel(String userLevel){
        this.userLevel = userLevel;
    }

    public void setPostId(int postId) {
        this.postId = postId;
    }


}
