package com.imyuewang.EduCity.model.vo;

import lombok.Data;
import lombok.experimental.Accessors;

import java.sql.Timestamp;
import java.util.Set;

/**
 * @ClassName UserVO
 * @Description User Value Object
 * @Author Yue Wang
 * @Date 2023/5/4 15:05
 * @Version 1.0
 **/
@Data
@Accessors(chain = true)
public class UserVO {

    private Long id;

    private String email;

    private String name;

    private String avatarStr;

    private Long citymap;

    private Timestamp logoutTime;

    private String activecode;

    public UserVO(){}
    public UserVO(String activeCode){
        activeCode = this.activecode;
    }

}
