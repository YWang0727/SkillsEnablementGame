package com.imyuewang.EduCity.model.vo;

import lombok.Data;

@Data
public class UserInfoVO {

    private String email;

    private String name;

    private byte[] avatar;

    private String avatarStr;

    private Long prosperity;

    private Long gold;

}
