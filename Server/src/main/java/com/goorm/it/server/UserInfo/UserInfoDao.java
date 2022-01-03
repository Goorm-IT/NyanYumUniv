package com.goorm.it.server.UserInfo;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

@Repository
public class UserInfoDao {
    @Autowired JdbcTemplate jt;

    public List<Map<String, ?>> selectAll() {
        return jt.query("select * from user", (rs, rowNum) -> {
            Map<String, Object> mss = new HashMap<>();
            mss.put("uid", rs.getString(1));
            mss.put("nickName", rs.getString(2));
            mss.put("postId", rs.getInt(3));
            return mss;
        });
    }
    public List<Map<String, Object>> checkUser(String uid) {
        return jt.query("select * from user where uid ='" + uid +"'", (rs, rowNum) -> {
            Map<String, Object> mss = new HashMap<>();
            mss.put("uid", rs.getString(1));
            mss.put("nickName", rs.getString(2));
            mss.put("postId", rs.getInt(3));
            return mss;
        });
    }

}