package com.goorm.it.server.UserInfo;

public class UserInfoDto {
    private String id;
    private String nickName;
    private int postId;

    public String getId(){
        return id;
    }
    public String getNickName(){
        return nickName;
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

    public void setPostId(int postId) {
        this.postId = postId;
    }

}
