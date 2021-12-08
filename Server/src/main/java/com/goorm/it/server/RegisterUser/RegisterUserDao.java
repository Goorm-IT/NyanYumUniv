package com.goorm.it.server.RegisterUser;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;
import java.sql.*;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class RegisterUserDao {

    @Autowired
    static JdbcTemplate jt;

    public static List<Map<String, ?>> add(){
        return jt.query("insert into userinfo (uid, nickName)", (rs, rowNum)->{
            Map<String, Object> mss = new HashMap<>();
            mss.put("uid", rs.getString(1));
            mss.put("nickName", rs.getString(2));
            return mss;
        });
    }

}
